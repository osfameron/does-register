package DoES::Register::Schema::Result::Cake;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column comment => {
    data_type => 'varchar',
    is_nullable => 0,
};

unique_column user_id => {
    data_type => 'int',
    is_nullable => 0,
};
 
unique_column topup_id => {
    data_type => 'int',
    is_nullable => 1,
};

unique_column visit_id => {
    data_type => 'int',
    is_nullable => 1,
};

belongs_to user  => 'DoES::Register::Schema::Result::User' => 'user_id';
belongs_to topup => 'DoES::Register::Schema::Result::Topup' => 'topup_id', { join_type => 'left' };
belongs_to visit => 'DoES::Register::Schema::Result::Visit', 'visit_id', { join_type => 'left' };
might_have cake => 'DoES::Register::Schema::Result::Cake';

1;