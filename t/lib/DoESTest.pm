package DoESTest;

use Moo;
extends 'DoES::Register';
use Test::PostgreSQL;
use DateTime;
use DoESTest::Profiler;

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

has '+config_root' => (
    default => sub { shift->root->child('t/conf') },
);

has profiler => (
    is => 'rw',
    clearer => 1,
    builder => sub { DoESTest::Profiler->new },
);

sub profile {
    my ($self, $state) = @_;
    $self->clear_profiler;
    my $profiler = $self->_build_profiler;
    $self->profiler($profiler);

    my $db = $self->db;
    $db->storage->debugobj($profiler) if $state;
    $db->storage->debug($state);
}


has app_dsn => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        $self->SUPER::dsn;
    },
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
