package DoES::Register::Management;

use Moo;
use MooX::Cmd;
use MooX::Options;
use Module::Load;

option class => (
    is => 'ro',
    format => 's',
    doc => 'override the class to instantiate',
    default => 'DoES::Register',
);

option test_class => (
    is => 'ro',
    format => 's',
    doc => 'override the class to instantiate',
    default => 'DoESTest',
);

has app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        my $class = $self->class;
        load $class;
        $class->new;
    },
);

has test_app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        my $class = $self->test_class;
        load $class;
        $class->new;
    },
);

sub execute {
    warn "No default behaviour TODO";
}

1;
