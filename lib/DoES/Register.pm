package DoES::Register;

use Moo;
use DoES::Register::Schema;
use DoES::Register::Handler;

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
        DoES::Register::Handler->handler;
    },
);

has time_zone => (
    is => 'ro',
    default => 'Europe/London',
);

sub now {
    my $self = shift;
    DateTime->now( time_zone => $self->time_zone );
}

1;
