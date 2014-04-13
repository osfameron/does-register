package DoESTest;

use Moo;
extends 'DoES::Register';
use Test::PostgreSQL;

has dsn => (
    is => 'lazy',
    # isa => 'Str',
    default => sub {
        my $self = shift;
        return $ENV{DOES_TEST_DSN} ||= $self->test_postgresql->dsn;
    }
);

has test_postgresql => (
    is => 'lazy',
    # isa => Test::PostgreSQL
    default => sub {
        Test::PostgreSQL->new;
    }
);

around db => sub {
    my $orig = shift;
    my $self = shift;
    my $db = $self->$orig(@_);
    $db->deploy unless $ENV{DOES_TEST_DB_DEPLOYED}++;
    $db;
};

1;
