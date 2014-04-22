package DoESTest;

use Moo;
extends 'DoES::Register';
use Test::PostgreSQL;
use FindBin;
use DateTime;

has '+db' => (
    default => sub {
        my $self = shift;
        my $db = $self->next::method;
        unless ($ENV{DOES_TEST_DB_DEPLOYED}++) {
            $db->deploy;
            $self->setup_fixtures($db);
        }
        return $db;
    }
);

has dsn => (
    is => 'lazy',
    # isa => 'Str',
    default => sub {
        my $self = shift;
        $ENV{DOES_TEST_DB_DEPLOYED}++ if $ENV{DOES_TEST_DSN};
        my $dsn = $ENV{DOES_TEST_DSN} ||= $self->test_postgresql->dsn;
        print STDERR "# DSN: $dsn\n";
        return $dsn;
    }
);

has test_postgresql => (
    is => 'lazy',
    # isa => Test::PostgreSQL
    default => sub {
        Test::PostgreSQL->new;
    }
);

sub setup_fixtures {
    # I never got on with DBIC::Fixtures, I just want to dump *everything* not
    # have to fiddle with configs.  Instead, we'll use this method for now.

    my ($self, $db) = @_;

    my $today  = DateTime->today;
    my $past   = $today->clone->subtract( days => 7 );
    my $future = $today->clone->add( days => 7 );

    my $member_rs = $db->resultset('Member');
    my $membership_rs = $db->resultset('Membership');

    my %types;
    for my $type ($db->resultset('MembershipType')->all) {
        $types{ $type->name } = $type;
    }

    my $member_a = $member_rs->create({ 
        name => 'Alice',
        memberships => [
            { type => $types{orga}, start_date => $past },
            { type => $types{perm}, start_date => $past },
        ],
    });
    my $visit_a = $member_a->create_related( 
        visits => {
            visit_date => $past,
            days_used => 0,
        });
    $member_a->create_related(
        cake => {
            comment => 'lemon drizzle',
            visit => $visit_a,
        });

    my $member_b = $member_rs->create({
        name => 'Bob',
        memberships => [
            { type => $types{perm}, start_date => $past },
        ],
    });

    my $member_c = $member_rs->create({
        name => 'Colin',
        memberships => [
            { type => $types{payg}, start_date => $past },
        ]
    });

    my $member_d = $member_rs->create({
        name => 'Deirdre',
        memberships => [
            { type => $types{payg}, start_date => $past },
        ],
        default_daily_usage_cap => 0.5,
        comment => 'Usually does half days',
    });
}

1;
