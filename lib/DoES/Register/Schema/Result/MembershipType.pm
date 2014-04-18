package DoES::Register::Schema::Result::MembershipType;

use DBIx::Class::Candy
    -autotable => v1,
    #-components => ['InflateColumn::DateTime', 'TimeStamp'];
    ;

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};
 
unique_column name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column unlimited => {
    data_type => 'boolean',
    is_nullable => 0,
    default_value => 0,
};

1;
