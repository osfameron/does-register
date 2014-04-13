package DoES::Register::Schema::Result::Visit;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column member_id => {
    data_type => 'int',
    is_nullable => 0,
};

column comment => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column created_date => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
};

column visit_date => {
    data_type => 'date',
    is_nullable => 0,
    set_on_create => 1,
};

column time_in => {
    data_type => 'time',
    is_nullable => 0,
    set_on_create => 1,
};

column time_out => {
    data_type => 'time',
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

belongs_to member => 'DoES::Register::Schema::Result::Member' => 'member_id';
unique_constraint [qw/ member_id visit_date /];

1;
