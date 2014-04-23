package DoES::Register::Schema::ResultSet::Visit;
use strict; use warnings;
use parent 'DBIx::Class::ResultSet';
use DateTime;

sub visits_on_day {
    my $self = shift;
    my $override_now = shift;
    my $now = $override_now || DateTime->today;

    my $dtf = $self->result_source->schema->storage->datetime_parser;

    my $NOW = $override_now ? sprintf q('%s'), $dtf->format_datetime($now) : 'NOW()';
    my $COND =       'me.time_out IS NOT NULL';
    my $TOTAL_TIME = 'EXTRACT(EPOCH FROM me.time_out - me.time_in) / 3600';
    my $ELAPSED_TIME = "EXTRACT(EPOCH FROM $NOW - me.time_in) / 3600";

    $self->search_rs(
        { 
            'me.visit_date' => $dtf->format_date($now),
        },
        {
            prefetch => [ 
                'cake', 
                'usage',
                { 'member' => [ { 'memberships' => 'type' }, 'topups', 'visits' ] }, 
            ],
            '+select' => [
                \"CASE WHEN $COND THEN $TOTAL_TIME ELSE null END",
                \"CASE WHEN $COND THEN $TOTAL_TIME ELSE $ELAPSED_TIME END",
                \"CASE WHEN $COND THEN $TOTAL_TIME NOT BETWEEN usage.min_hours AND usage.max_hours ELSE $ELAPSED_TIME > usage.max_hours END"
            ],
            '+as' => [
                'total_time',
                'elapsed_time',
                'flagged_hours',
            ],
        }
    );
}

sub visit_now {
    my ($self, $member, $override_now) = @_;
    my $now = $override_now || DateTime->now;

    my $dtf = $self->result_source->schema->storage->datetime_parser;

    my $visit = $self->find_or_create({
        member     => $member,
        visit_date => $dtf->format_date($now),
        time_in    => $dtf->format_datetime($now),
    });

    return $visit;
}

1;
