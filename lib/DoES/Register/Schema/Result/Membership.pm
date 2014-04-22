package DoES::Register::Schema::Result::Membership;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

column member_id => {
    data_type => 'int',
};

column membership_type_id => {
    data_type => 'int',
};
 
column start_date => {
    data_type => 'date',
};

column end_date => {
    data_type => 'date',
    is_nullable => 1,
};

belongs_to member => 'DoES::Register::Schema::Result::Member' => 'member_id';
belongs_to type => 'DoES::Register::Schema::Result::MembershipType' => 'membership_type_id';

subclass;
1;
