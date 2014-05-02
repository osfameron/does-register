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
            my ($self) = @_;
            $handler->emit_visits($self);
            $handler->emit_members($self);
        });

    }
}

sub emit_visits {
    my ($self, $socket) = @_;

    my @visits = map $_->to_struct,
        $self->db->resultset('Visit')->visits_on_day->all;

    $socket->emit( visits => \@visits );
}

sub emit_members {
    my ($self, $socket) = @_;

    my @members = map +{ $_->get_columns },
        $self->db->resultset('Member')->not_currently_visiting->all;

    $socket->emit( members => \@members );
}

1;
