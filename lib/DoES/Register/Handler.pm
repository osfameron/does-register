package DoES::Register::Handler;
use Moo;
use PocketIO;

has db => (
    is => 'ro',
);

sub run {
    my $handler = shift;
    return sub {
        my $self = shift;

        $self->on( message => sub {
            warn join ',' => @_;
        });

        $self->on( hello => sub {
                my ($self, $fun) = @_;

                my @visits = map $_->to_struct,
                    $handler->db->resultset('Visit')->visits_on_day->all;

                $self->emit( members => \@visits );
            }
        );
    }
}

1;
