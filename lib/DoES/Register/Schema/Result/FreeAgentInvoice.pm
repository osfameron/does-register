package DoES::Register::Schema::Result::FreeAgentInvoice;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

column freeagent_id => {
    data_type => 'int',
};

column freeagent_invoice_date => {
    data_type => 'timestamp with time zone',
    timezone => 'UTC',
};

column amount => {
    data_type => 'numeric(5,2)',
};
 
column freeagent_contact_id => {
    data_type => 'int',
};

column description => {
    data_type => 'varchar',
    size => 255,
    default_value => '',
};

belongs_to freeagent_contact => 
    'DoES::Register::Schema::Result::FreeAgentContact' => freeagent_contact_id => {join_type => 'left'};

subclass;
1;

