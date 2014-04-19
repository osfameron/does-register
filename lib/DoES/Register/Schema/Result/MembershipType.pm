package DoES::Register::Schema::Result::MembershipType;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

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

subclass;
1;
