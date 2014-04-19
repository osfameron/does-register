package DoES::Register::Schema::Result::Membership;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

column user_id => {
    data_type => 'int',
    is_nullable => 0,
};

column membership_type_id => {
    data_type => 'int',
    is_nullable => 0,
};
 
column name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column start_date => {
    data_type => 'date',
    is_nullable => 0,
};

column end_date => {
    data_type => 'date',
    is_nullable => 1,
};

belongs_to user => 'DoES::Register::Schema::Result::User' => 'user_id';
belongs_to type => 'DoES::Register::Schema::Result::MembershipType' => 'membership_type_id';

subclass;
1;
