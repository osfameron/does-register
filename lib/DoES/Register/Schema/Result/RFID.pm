package DoES::Register::Schema::Result::RFID;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column rfid => {
    data_type => 'int',
    is_nullable => 0,
};
 
column user_id => {
    data_type => 'int',
    is_nullable => 1,
};

column created_date => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
};

column updated_date => {
    data_type => 'datetime',
    is_nullable => 1,
    set_on_update => 1,
};

belongs_to user  => 'DoES::Register::Schema::Result::User' => 'user_id', { join_type => 'left' };

1;

