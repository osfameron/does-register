package DoES::Register::Schema::ResultSet::Member;
use strict; use warnings;
use parent 'DBIx::Class::ResultSet';
use DateTime;

sub not_currently_visiting {
    my $self = shift;
    my $override_now = shift;
    my $now = $override_now || DateTime->today;

    my $dtf = $self->result_source->schema->storage->datetime_parser;

    $self->search_rs(
        { },
        {
            '+select' => [ { max => 'visit_date' } ],
            '+as' =>     [qw{ max_visit_date }],
            join => 'visits',
            distinct => 1,
            having => \[ '( max(visits.visit_date) < ? OR max(visits.visit_date) is NULL )' => [ max => $dtf->format_date($now) ] ],
        }
    );
}

1;
