package DoESTest;

use Moo;
extends 'DoES::Register';
use Test::PostgreSQL;
use FindBin;
use DateTime;

has dsn => (
    is => 'lazy',
    # isa => 'Str',
    default => sub {
        my $self = shift;
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

    my $type_rs = $db->resultset('MembershipType');
    my %types = (
        orga     => $type_rs->create({ name => 'orga' }),
        tech     => $type_rs->create({ name => 'tech',     unlimited => 1 }), # technician, interns etc.
        service  => $type_rs->create({ name => 'service',  unlimited => 1 }), # cleaner, etc.
        perm     => $type_rs->create({ name => 'perm',     unlimited => 1 }),
        workshop => $type_rs->create({ name => 'workshop', unlimited => 1 }),
        payg     => $type_rs->create({ name => 'payg' }),
        friend   => $type_rs->create({ name => 'friend' }),
        fwb      => $type_rs->create({ name => 'fwb' }),
    );

    my $user_rs = $db->resultset('User');
    my $membership_rs = $db->resultset('Membership');

    my $user_a = $user_rs->create({ 
        name => 'Alice',
        memberships => [
            { type => $types{orga}, start_date => $past },
            { type => $types{perm}, start_date => $past },
        ],
    });
    my $visit_a = $user_a->create_related( 
        visits => {
            visit_date => $past,
            days_used => 0,
        });
    $user_a->create_related(
        cake => {
            comment => 'lemon drizzle',
            visit => $visit_a,
        });

    my $user_b = $user_rs->create({
        name => 'Bob',
        memberships => [
            { type => $types{perm}, start_date => $past },
        ],
    });

    my $user_c = $user_rs->create({
        name => 'Colin',
        memberships => [
            { type => $types{payg}, start_date => $past },
        ]
    });
}

around db => sub {
    my $orig = shift;
    my $self = shift;
    my $db = $self->$orig(@_);
    $db->deploy unless $ENV{DOES_TEST_DB_DEPLOYED}++;
    $self->setup_fixtures($db);
    return $db;
};

1;
