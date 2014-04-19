package DoES::Register::Schema::Result::RFID;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

column rfid => {
    data_type => 'int',
    is_nullable => 0,
};
 
column user_id => {
    data_type => 'int',
    is_nullable => 1,
};

belongs_to user  => 'DoES::Register::Schema::Result::User' => 'user_id', { join_type => 'left' };

subclass;

1;
