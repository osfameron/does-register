package DoES::Register::Schema::Result::FreeAgentInvoice;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

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

belongs_to freeagent_contact => 
    'DoES::Register::Schema::Result::FreeAgentContact' => freeagent_contact_id => {join_type => 'left'};

1;

