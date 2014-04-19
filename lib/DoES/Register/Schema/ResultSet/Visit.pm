package DoES::Register::Schema::ResultSet::Visit;
use strict; use warnings;
use parent 'DBIx::Class::ResultSet';
use DateTime;

sub visits_on_day {
    my $self = shift;
    my $day = shift || DateTime->today;

    my $dtf = $self->result_source->schema->storage->datetime_parser;

    my $COND =       'me.time_out IS NOT NULL';
    my $TOTAL_TIME = 'EXTRACT(EPOCH FROM me.time_out - me.time_in) / 3600';

    $self->search_rs(
        { 
            visit_date => $dtf->format_date($day),
        },
        {
            prefetch => [ 'cake', 'member', 'usage' ],
            '+select' => [
                \"CASE WHEN $COND THEN $TOTAL_TIME ELSE null END",
                \"CASE WHEN $COND THEN $TOTAL_TIME NOT BETWEEN usage.min_hours AND usage.max_hours ELSE false END"
            ],
            '+as' => [
                'total_time',
                'flagged_hours',
            ],
        }
    );
}

sub visit_now {
    my ($self, $member) = @_;
    my $now = DateTime->now;

    $self->find_or_create({
        member => $member,
        visit_date => $now,
        time_in => $now,
    });
}

1;
