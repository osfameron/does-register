use strict; use warnings;
use Test::Most;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";
use DateTime;

use DoESTest;

my $app = DoESTest->new;

my $db = $app->db;

subtest 'sanity' => sub {
    is $db->resultset('MembershipType')->count, 8;
    is $db->resultset('User')->count, 3;
    is $db->resultset('Membership')->count, 4;
};

my $user_rs = $db->resultset('User');

subtest 'alice (orga/perm)' => sub {
    my $user_a = $user_rs->find({ name => 'Alice' });
    ok $user_a, 'Alice retrieved' and do {
        ok $user_a->cake, 'Alice has had cake day';
    };

    # check that inheritance structure is OK
    can_ok $user_a, qw/ id created_date updated_date comment /; 

    check_times( $user_a, [
        [ '09:30' => '0.00' ],
        [ '12:30' => '0.00' ],
        [ '18:30' => '0.00' ],
    ]);
};

subtest 'bob' => sub {
    my $user_b = $user_rs->find({ name => 'Bob' });
    ok $user_b, 'Bob retrieved' and do {
        ok ! $user_b->cake, 'Bob has not had cake day';
    };
};

subtest 'colin (payg)' => sub {
    my $user_c = $user_rs->find({ name => 'Colin' });
    ok $user_c, 'Colin retrieved' and do {
        ok ! $user_c->cake, 'Colin has not had cake day';
    };

    check_times( $user_c, [
        [ '09:30' => '1.00' ],
        [ '12:30' => '0.50' ],
        [ '18:30' => '0.25' ],
    ]);

    $db->txn_begin;
    $user_c->update({ default_daily_usage_cap => '0.50' });
    check_times( $user_c, [
        [ '09:30' => '0.50' ],
        [ '12:30' => '0.50' ],
        [ '18:30' => '0.25' ],
    ]);
    $db->txn_rollback;
};

sub check_times {
    my ($user, $times) = @_;
    my $today  = DateTime->today;
    for (@$times) {
        my ($time_in, $days_used) = @$_;
        my ($hh,$mm) = split /:/, $time_in;

        my $visit = $user->visits->new({
            visit_date => $today,
            time_in => $today->clone->set( hour => $hh, minute => $mm ),
        });
        is $visit->days_used, $days_used, "In $time_in, days_used $days_used";
    }
}

done_testing;
