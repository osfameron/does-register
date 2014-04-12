package DoES::Register::Handler;
use Moo;
use PocketIO;

sub handler {
    my $class = shift;
    return PocketIO->new(
        class => $class,
        method => 'run',
    );
}

sub run {
    return sub {
        my $self = shift;

        $self->on( message => sub {
            warn join ',' => @_;
        });

        $self->on( hello => sub {
                my ($self, $fun) = @_;

                $self->emit( members => ['TODO'] );
            }
        );
    }
}

1;
