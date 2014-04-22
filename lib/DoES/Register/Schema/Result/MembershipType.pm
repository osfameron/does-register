package DoES::Register::Schema::Result::MembershipType;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

unique_column name => {
    data_type => 'varchar',
    size => 255,
};

column unlimited => {
    data_type => 'boolean',
    default_value => 0,
};

subclass;
1;
