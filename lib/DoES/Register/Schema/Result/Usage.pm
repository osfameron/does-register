package DoES::Register::Schema::Result::Usage;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

unique_column days_used => {
    data_type => 'numeric(3,2)',
    is_nullable => 0,
};

column min_hours => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 0,
};

column max_hours => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 24,
};

column cutoff => {
    data_type => 'time',
    is_nullable => 0,
    default_value => '0:00',
};

subclass;

1;
