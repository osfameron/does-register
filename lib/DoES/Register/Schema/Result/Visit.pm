package DoES::Register::Schema::Result::Visit;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

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
    default_value => 1, # but override with checkin-time calculation
                        # supplemented with user's default_daily_usage_cap
};

# ideally we should log guests are people too, but sometimes not practical so
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

1;
