package DoES::Register::Schema::Commentable;
use parent 'DoES::Register::Schema::BaseObject';

use DBIx::Class::Candy;

table 'BaseCommentable'; # DUMMY

column comment => {
    data_type => 'varchar',
    default_value => '',
};

1;
