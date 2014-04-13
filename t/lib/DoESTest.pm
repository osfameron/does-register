package DoESTest;

use Moo;
extends 'DoES::Register';
use Test::PostgreSQL;
use FindBin;

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
    # have to fiddle with configs
    my ($self, $db) = @_;

    my $type_rs = $db->resultset('Type');
    $type_rs->create({ name => 'orga' });
    $type_rs->create({ name => 'perm', unlimited => 1 });
    $type_rs->create({ name => 'ws', unlimited => 1 });
    $type_rs->create({ name => 'friend' });
    $type_rs->create({ name => 'fwb' });
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
