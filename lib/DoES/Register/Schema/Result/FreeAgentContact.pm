package DoES::Register::Schema::Result::FreeAgentContact;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

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

subclass;
1;

