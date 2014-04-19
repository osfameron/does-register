package DoES::Register::Schema::ResultSet::Visit;
use parent 'DBIx::Class::ResultSet';
use DateTime;

sub visits_on_day {
    my $self = shift;
    my $day = shift || DateTime->today;

    $self->search_rs(
        { 
            visit_date => $day,
        },
        {
            prefetch => [ 'cake', 'user' ],
        }
    );
}

sub new_visit {
    my ($self, $user) = @_;
    my $now = DateTime->now;

    $self->create({
        user => $user,
        visit_date => $now,
        time_in => $now,
    });
}

1;
