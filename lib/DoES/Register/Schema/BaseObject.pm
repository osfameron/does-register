package DoES::Register::Schema::BaseObject;

use DBIx::Class::Candy
    -components => [ 'InflateColumn::DateTime', 'TimeStamp', 'Helper::Row::SubClass' ];

table 'Base'; # DUMMY

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column created_date => {
    data_type => 'datetime',
    timezone => 'UTC',
    set_on_create => 1,
};

column updated_date => {
    data_type => 'datetime',
    timezone => 'UTC',
    is_nullable => 1,
    set_on_update => 1,
};

1;
