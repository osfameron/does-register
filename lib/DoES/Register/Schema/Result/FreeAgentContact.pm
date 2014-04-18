package DoES::Register::Schema::Result::FreeAgentContact;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column freeagent_id => {
    data_type => 'int',
    is_nullable => 1,
};
 
column name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 0,
};

column email => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column twitter => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column website => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column tel => {
    data_type => 'varchar',
    size => 255,
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

1;

