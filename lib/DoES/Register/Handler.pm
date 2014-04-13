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

                $self->emit( members => [
                    {
                        name => 'Henry',
                        active => 1,
                        icon => "https://secure.gravatar.com/avatar/6cc00f9bf5a38125e2514ae33e170e96?s=130&d=identicon",
                        types => 'Orga,Perm',
                        left => 0,
                        used => 0,
                        in => '9:30',
                        out=> undef,
                    }
                ]);
            }
        );
    }
}

1;
