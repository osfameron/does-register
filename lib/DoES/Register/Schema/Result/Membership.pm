package DoES::Register::Schema::Result::Membership;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

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

column start_date => {
    data_type => 'datetime',
    is_nullable => 0,
};

column end_date => {
    data_type => 'datetime',
    is_nullable => 1,
};

belongs_to user => 'DoES::Register::Schema::Result::User' => 'user_id';
belongs_to type => 'DoES::Register::Schema::Result::MembershipType' => 'membership_type_id';

1;
