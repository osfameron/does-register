use strict; use warnings;
use feature 'say';

use Test::Most;
use Test::Deep;
use Test::MockTime ':all';
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

use DateTime;
use DoESTest;

my $app = DoESTest->new;
my $db = $app->db;

sub today {
    DateTime->today->set_time_zone($app->time_zone);
}

subtest 'sanity' => sub {
    is $db->resultset('MembershipType')->count, 8;
    is $db->resultset('Member')->count, 4;
    is $db->resultset('Membership')->count, 5;
};

my $member_rs = $db->resultset('Member');
my $visit_rs = $db->resultset('Visit');

my $member_a = $member_rs->find({ name => 'Alice' });
subtest 'alice (orga/perm)' => sub {
    ok $member_a, 'Alice retrieved' and do {
        ok $member_a->cake, 'Alice has had cake day';

        # check that inheritance structure is OK
        can_ok $member_a, qw/ id created_date updated_date comment /; 

        check_times( $member_a, [
            [ '09:30' => '0.00' ],
            [ '12:30' => '0.00' ],
            [ '18:30' => '0.00' ],
        ]);

        check_visit_flagged( $member_a, 9 => 11, undef, 0.00, 0, '0 usage never flagged' );
        check_visit_flagged( $member_a, 9 => 17, undef, 0.00, 0, '0 usage never flagged' );
        check_visit_flagged( $member_a, 9 => undef, 23, 0.00, 0, '0 usage never flagged' );
    };
};

my $member_b = $member_rs->find({ name => 'Bob' });
subtest 'bob' => sub {
    ok $member_b, 'Bob retrieved' and do {
        ok ! $member_b->cake, 'Bob has not had cake day';

        check_visit_flagged( $member_b, 9 => 12, undef, 0.50, 0, 'Half day not flagged' );
        check_visit_flagged( $member_b, 9 => undef, 11, 0.50, 0, 'Half day not yet clocked out not flagged' );
        check_visit_flagged( $member_b, 9 => 17, undef, 0.50, 1, 'Overly long half day flagged' );
        check_visit_flagged( $member_b, 9 => undef, 17, 0.50, 1, 'Unclocked-out half day flagged' );
        check_visit_flagged( $member_b, 9 => 17, undef, 1.00, 0, 'Full day not flagged' );
        check_visit_flagged( $member_b, 9 => undef, 16, 1.00, 0, 'Full day not yet clocked out not flagged' );
        check_visit_flagged( $member_b, 9 => undef, 18, 1.00, 0, 'Full day never clocked out flagged' );
        check_visit_flagged( $member_b, 9 => 11, undef, 1.00, 1, 'Overly short full day flagged' );
    };
};

subtest 'colin (payg)' => sub {
    my $member_c = $member_rs->find({ name => 'Colin' });
    ok $member_c, 'Colin retrieved' and do {
        ok ! $member_c->cake, 'Colin has not had cake day';

        check_times( $member_c, [
            [ '09:30' => '1.00' ],
            [ '12:30' => '0.50' ],
            [ '18:30' => '0.25' ],
        ]);
    };
};

my $member_d = $member_rs->find({ name => 'Deirdre' });
subtest 'deirdre (payg halfdays)' => sub {
    ok $member_d, 'Deirdre retrieved' and do {
        ok ! $member_d->cake, 'Colin has not had cake day';

        check_times( $member_d, [
            [ '09:30' => '0.50' ],
            [ '12:30' => '0.50' ],
            [ '18:30' => '0.25' ],
        ]);
    };
};

sub check_times {
    my ($member, $times) = @_;
    for (@$times) {
        my ($time_in, $days_used) = @$_;
        my ($hh,$mm) = split /:/, $time_in;

        my $visit = $member->visits->new({
            visit_date => today,
            time_in => today->set( hour => $hh, minute => $mm ),
        });
        is $visit->days_used, $days_used, "In $time_in, days_used $days_used";
    }
}

sub check_visit_flagged {
    my ($member, $in, $out, $time_now, $days_used, $flagged, $desc) = @_;

    # NB: we're overriding whatever the default days_used would be here

    $db->txn_begin;
    my $now = today->set( hour => $out // $time_now, minute => 0 );
    set_absolute_time( $now );

    $member->visits->create({
        visit_date => today,
        time_in => today->set( hour => $in, minute => 0 ),
        time_out => $out ? $now : undef,
        days_used => $days_used,
    });

    my $visit = $visit_rs->visits_on_day($now)->first;
    is $visit->flagged_hours, $flagged, $desc
        or diag Dumper({ $visit->get_columns });

    # as well as the optimized flagging from DB search, we can calculate
    # flagged_hours within the DB object.  Check we get same result
    $visit->discard_changes;
    is $visit->flagged_hours, $flagged, $desc
        or diag Dumper({ $visit->get_columns });

    $db->txn_rollback;
    restore_time;
}

subtest 'members available to visit' => sub {
    $db->txn_begin;

    my @members = $member_rs->all;
    my $current_count = scalar @members;

    my $time_in = 9;

    # $TODO, $now should be in summertime
    for my $member (@members) {
        my $now = today->set( hour => $time_in++, minute => 0 );

        set_absolute_time( $now );
        is $member_rs->not_currently_visiting()->count, $current_count,
            "Correct number of members available to visit ($current_count)";
        $visit_rs->visit_now($member, $now);
        $current_count--;
    }
    is $member_rs->not_currently_visiting()->count, 0, 'No more members';

    my $visits = $visit_rs->visits_on_day;
    is $visits->count, 4, '4 visits';
    my $visits_struct = [ map $_->to_struct, $visits->all ];
    cmp_deeply $visits_struct,
        [
          {
            'out' => undef,
            'left' => 0,
            'icon' => re('https?:.*'),
            'types' => [
                         'orga',
                         'perm'
                       ],
            'active' => 1,
            'name' => 'Alice',
            'flagged_hours' => 0,
            'in' => '09:00:00',
            'used' => 0
          },
          {
            'out' => undef,
            'left' => 0,
            'icon' => re('https?:.*'),
            'types' => [
                         'perm'
                       ],
            'active' => 1,
            'name' => 'Bob',
            'flagged_hours' => 0,
            'in' => '10:00:00',
            'used' => 0
          },
          {
            'out' => undef,
            'left' => 0,
            'icon' => 'https://secure.gravatar.com/avatar/6cc00f9bf5a38125e2514ae33e170e96?s=130&d=identicon',
            'types' => [
                         'payg'
                       ],
            'active' => 1,
            'name' => 'Colin',
            'flagged_hours' => 0,
            'in' => '11:00:00',
            'used' => 0
          },
          {
            'out' => undef,
            'left' => 0,
            'icon' => 'https://secure.gravatar.com/avatar/6cc00f9bf5a38125e2514ae33e170e96?s=130&d=identicon',
            'types' => [
                         'payg'
                       ],
            'active' => 1,
            'name' => 'Deirdre',
            'flagged_hours' => 1,
            'in' => '12:00:00',
            'used' => 0
          }
        ], 'Visits structure ok';

    restore_time;
    $db->txn_rollback;
};

done_testing;
