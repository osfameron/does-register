package DoES::Register::Schema::Commentable;
use parent 'DoES::Register::Schema::BaseObject';

__PACKAGE__->table('BaseCommentable'); # DUMMY

__PACKAGE__->add_columns( comment => {
    data_type => 'varchar',
    is_nullable => 0,
    default_value => '',
});

1;
