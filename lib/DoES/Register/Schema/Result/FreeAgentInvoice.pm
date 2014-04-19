package DoES::Register::Schema::Result::FreeAgentInvoice;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

column freeagent_id => {
    data_type => 'int',
    is_nullable => 0,
};

column amout => {
    data_type => 'numeric(5,2)',
    is_nullable => 0,
};
 
column freeagent_contact_id => {
    data_type => 'int',
    is_nullable => 0,
};

column description => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 0,
    default_value => '',
};

belongs_to freeagent_contact => 
    'DoES::Register::Schema::Result::FreeAgentContact' => freeagent_contact_id => {join_type => 'left'};

subclass;
1;

