package DoES::Register::Schema::Result::Topup;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column member_id => {
    data_type => 'int',
    is_nullable => 0,
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

column is_cake_day => {
    data_type => 'boolean',
    is_nullable => 0,
    default_value => 0,
};

belongs_to member => 'DoES::Register::Schema::Result::Member' => 'member_id';

1;
