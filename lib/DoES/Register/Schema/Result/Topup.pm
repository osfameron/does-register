package DoES::Register::Schema::Result::Topup;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

column user_id => {
    data_type => 'int',
    is_nullable => 0,
};

column topup_date => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
};

column days => {
    data_type => 'int',
    is_nullable => 0,
};

column cost => {
    data_type => 'numeric(5,2)',
    is_nullable => 0,
};

column freeagent_invoice_id => {
    data_type => 'int',
    is_nullable => 1,
};

belongs_to user => 'DoES::Register::Schema::Result::User' => 'user_id';

subclass;

1;
