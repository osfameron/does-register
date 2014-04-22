package DoES::Register::Schema::Result::Topup;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

column member_id => {
    data_type => 'int',
};

column topup_date => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

column days => {
    data_type => 'int',
};

column cost => {
    data_type => 'numeric(5,2)',
};

column freeagent_invoice_id => {
    data_type => 'int',
    is_nullable => 1,
};

belongs_to member => 'DoES::Register::Schema::Result::Member' => 'member_id';

subclass;

1;
