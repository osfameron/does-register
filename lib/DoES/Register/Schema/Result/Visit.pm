package DoES::Register::Schema::Result::Visit;

use Class::Method::Modifiers;
use DoES::Register::Schema::Candy
    -base => 'Commentable';

use List::Util 'min';

column user_id => {
    data_type => 'int',
    is_nullable => 0,
};

column visit_date => {
    data_type => 'date',
    is_nullable => 0,
    set_on_create => 1,
};

column time_in => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
};

column time_out => {
    data_type => 'datetime',
    is_nullable => 1,
};

column days_used => {
    data_type => 'numeric(3,2)',
    is_nullable => 0,
    default_value => 1.00, # but override with checkin-time calculation
                           # supplemented with user's default_daily_usage_cap
};

# ideally we should log guests as people too, but sometimes not practical so
# we allow a +1 column...
column num_guests => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 0,
};

belongs_to user => 'DoES::Register::Schema::Result::User' => 'user_id';
unique_constraint [qw/ user_id visit_date /];
might_have cake => 'DoES::Register::Schema::Result::Cake', 'visit_id';

subclass;

around new => sub {
    my ($orig, $class, $args) = @_;
    my $self = $class->$orig($args);
    unless (defined $args->{days_used}) {
       $self->days_used( $self->get_initial_days_used );
    }
    return $self;
};

sub get_initial_days_used {
    my $self = shift;
    my $user = $self->user;
    return '0.00' if $user->unlimited;
    my $cap = $user->default_daily_usage_cap or return '0.00';

    my $day_rs = $self->result_source->schema->resultset('Day');

    # TODO move to ::RS::Day
    my $guess = $day_rs->search(
        {
            cutoff => { '<=', $self->time_in->time },
        },
        {
            order_by => [ 'cutoff DESC', 'days_used DESC' ],
        }
    )->first->days_used;

    return min( $guess, $cap );
}

1;
