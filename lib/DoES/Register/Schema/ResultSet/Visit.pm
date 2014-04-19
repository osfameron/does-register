package DoES::Register::Schema::ResultSet::Visit;
use strict; use warnings;
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

sub visit_now {
    my ($self, $user) = @_;
    my $now = DateTime->now;

    $self->find_or_create({
        user => $user,
        visit_date => $now,
        time_in => $now,
    });
}

1;
