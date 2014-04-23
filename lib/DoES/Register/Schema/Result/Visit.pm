package DoES::Register::Schema::Result::Visit;

use Class::Method::Modifiers;
use DoES::Register::Schema::Candy
    -base => 'Commentable';

use List::Util 'min';

column member_id => {
    data_type => 'int',
};

column visit_date => {
    data_type => 'date',
    set_on_create => 1,
    timezone => 'UTC',
};

column time_in => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
    timezone => 'UTC',
};

column time_out => {
    data_type => 'timestamp with time zone',
    is_nullable => 1,
    timezone => 'UTC',
};

column days_used => {
    data_type => 'numeric(3,2)',
    default_value => 1.00, # but see below
};

# ideally we should log guests as people too, but sometimes not practical so
# we allow a +1 column...
column num_guests => {
    data_type => 'int',
    default_value => 0,
};

belongs_to member => 'DoES::Register::Schema::Result::Member' => 'member_id';
unique_constraint [qw/ member_id visit_date /];
might_have cake => 'DoES::Register::Schema::Result::Cake', 'visit_id';
has_one usage => 'DoES::Register::Schema::Result::Usage', { 'foreign.days_used' => 'self.days_used' };

subclass;

around new => sub {
    my ($orig, $class, $args) = @_;
    my $self = $class->$orig($args);
    die "No time_in passed" unless $self->time_in; # bit odd, but constraint isn't checked till insertion
    unless (defined $args->{days_used}) {
       $self->days_used( $self->get_initial_days_used );
    }
    return $self;
};

sub get_initial_days_used {
    my $self = shift;
    my $member = $self->member;
    return '0.00' if $member->unlimited;
    my $cap = $member->default_daily_usage_cap or return '0.00';

    my $usage_rs = $self->result_source->schema->resultset('Usage');

    # TODO move to ::RS::Day
    my $guess = $usage_rs->search(
        {
            cutoff => { '<=', $self->time_in->time },
        },
        {
            order_by => [ 'cutoff DESC', 'days_used DESC' ],
        }
    )->first->days_used;

    return min( $guess, $cap );
}

sub total_time { # in fractional hours
    my $self = shift;

    return $self->get_column('total_time') if $self->has_column_loaded('total_time');

    my $time_out = $self->time_out or return;
    my $time_in = $self->time_in;

    return ($time_out->epoch - $time_in->epoch) / 3600;
}

sub elapsed_time {
    my $self = shift;
    return $self->get_column('elapsed_time') if $self->has_column_loaded('elapsed_time');

    return $self->total_time // do {
        my $time_in = $self->time_in;
        my $now = DateTime->now;
        return ($now->epoch - $time_in->epoch) / 3600;
    };
}

sub flagged_hours {
    my $self = shift;
    return $self->get_column('flagged_hours') if $self->has_column_loaded('flagged_hours');

    my $usage = $self->usage;
    my $total_time = $self->total_time;

    if (defined $total_time) {
        return 1 if $total_time < $self->usage->min_hours;
    }

    my $elapsed_time = $self->elapsed_time;

    return 1 if $elapsed_time > $self->usage->max_hours;

    return 0;
}

sub to_struct {
    my ($self, $time_zone) = @_;
    my $member = $self->member;

    $time_zone ||= 'Europe/London';

    my $time_in = $self->time_in->set_time_zone($time_zone)->time;
    my $time_out = $self->time_out ? $self->time_out->set_time_zone($time_zone)->time : undef;

    return {
        name => $member->name,
        active => ! $self->time_out,
        icon => "https://secure.gravatar.com/avatar/6cc00f9bf5a38125e2514ae33e170e96?s=130&d=identicon",
        types => [ map $_->type->name, $member->memberships ],
        left => 0,
        used => 0,
        in => $time_in,
        out=> $time_out,
        flagged_hours => $self->flagged_hours,
    }
}


1;
