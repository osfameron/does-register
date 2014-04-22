package DoES::Register::Schema::Result::Usage;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

unique_column days_used => {
    data_type => 'numeric(3,2)',
};

column min_hours => {
    data_type => 'int',
    default_value => 0,
};

column max_hours => {
    data_type => 'int',
    default_value => 24,
};

column cutoff => {
    data_type => 'time',
    default_value => '0:00',
};

subclass;

1;
