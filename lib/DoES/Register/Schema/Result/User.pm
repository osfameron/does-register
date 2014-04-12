package DoES::Register::Schema::Result::User;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};
 
column name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column comment => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column created_date => {
    data_type => 'datetime',
    is_nullable => 0,
};

column updated_date => {
    data_type => 'datetime',
    is_nullable => 1,
};

column default_daily_usage_cap => {
    data_type => 'int',
    is_nullable => 0,
    default => 1,
};

1;

