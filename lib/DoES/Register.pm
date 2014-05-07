package DoES::Register;

use Moo;
use DoES::Register::Schema;
use DoES::Register::Handler;
use DoES::Register::Twitter;
use Path::Tiny 'path';
use Dir::Self;

has root => (
    is => 'lazy',
    default => sub { path(__DIR__)->parent(2) },
);

has config_root => (
    is => 'lazy',
    default => sub { $_[0]->root->child('conf') },
);

has dsn => (
    is => 'lazy',
    # isa => 'Str',
    default => 'dbi:Pg:dbname=doesregister',
);

has connect_info => (
    is => 'lazy',
    # isa => 'ArrayRef',
    default => sub { [ shift->dsn ] },
);

has db => (
    is => 'lazy',
    default => sub {
        DoES::Register::Schema->connect(@{ shift->connect_info });
    }
);

has pocket_io => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        return PocketIO->new(
            instance => DoES::Register::Handler->new(
                db => $self->db,
                app => $self,
            ),
            method => 'run',
        );
    },
);

has time_zone => (
    is => 'ro',
    default => 'Europe/London',
);

has twitter => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        return DoES::Register::Twitter->new( config_root => $self->config_root ),
    },
);

sub now {
    my $self = shift;
    DateTime->now( time_zone => $self->time_zone );
}

1;
