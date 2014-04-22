package DoES::Register::Schema::Result::Member;

use DoES::Register::Schema::Candy
    -base => 'Commentable';

column freeagent_contact_id => {
    data_type => 'int',
    is_nullable => 1,
};
 
column name => {
    data_type => 'varchar',
    size => 255,
};

column default_daily_usage_cap => {
    data_type => 'numeric(3,2)',
    default_value => 1.00,
};

might_have cake      => 'DoES::Register::Schema::Result::Cake', 'member_id';
has_many memberships => 'DoES::Register::Schema::Result::Membership', 'member_id';
has_many visits      => 'DoES::Register::Schema::Result::Visit', 'member_id';

# make sure usage cap is set up in DB
has_one usage => 'DoES::Register::Schema::Result::Usage', 
    { 'foreign.days_used' => 'self.default_daily_usage_cap' };

subclass;

sub unlimited {
    my $self = shift;
    return $self->memberships->find(
        { 'type.unlimited' => 1 },
        { join => 'type' },
    );
}

1;
