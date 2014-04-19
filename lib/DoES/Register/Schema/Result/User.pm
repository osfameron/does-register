package DoES::Register::Schema::Result::User;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

column freeagent_contact_id => {
    data_type => 'int',
    is_nullable => 1,
};
 
column name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 0,
};

column default_daily_usage_cap => {
    data_type => 'numeric(3,2)',
    is_nullable => 0,
    default_value => 1.00,
};

might_have cake      => 'DoES::Register::Schema::Result::Cake', 'user_id';
has_many memberships => 'DoES::Register::Schema::Result::Membership', 'user_id';
has_many visits      => 'DoES::Register::Schema::Result::Visit', 'user_id';

subclass;

1;

