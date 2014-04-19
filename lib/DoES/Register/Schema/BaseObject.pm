package DoES::Register::Schema::BaseObject;

# couldn't figure out how to set up base object in Candy, TODO
use strict; use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components( 'InflateColumn::DateTime', 'TimeStamp', 'Helper::Row::SubClass', 'Core' );

__PACKAGE__->table('Base'); # DUMMY

__PACKAGE__->add_columns( id => {
    data_type => 'int',
    is_auto_increment => 1,
});

__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_columns( created_date => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
});

__PACKAGE__->add_columns( updated_date => {
    data_type => 'datetime',
    is_nullable => 1,
    set_on_update => 1,
});

1;
