package DoES::Register::Schema::Result::Induction;

use DBIx::Class::Candy
    -autotable => v1,
    -components => ['InflateColumn::DateTime', 'TimeStamp'];

primary_column id => {
    data_type => 'int',
    is_auto_increment => 1,
};

column user_id => {
    data_type => 'int',
    is_nullable => 0,
};

column sent_to_email => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 0,
};

column first_name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 0,
};

column last_name => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column company => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column billing_address => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column email_address => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};

column phone_number => {
    data_type => 'varchar',
    size => 255,
    is_nullable => 1,
};
 
column created_date => {
    data_type => 'datetime',
    is_nullable => 0,
    set_on_create => 1,
};

for my $col (qw/ 
        knows_location_toilets
        knows_location_fire_exits
        knows_location_kitchen
        knows_contact_details
        knows_about_workshop
        knows_items_left_at_own_risk
        knows_clear_desk_policy
        knows_about_mailing_list
        knows_about_doorbot
        knows_about_wiki
        opt_out_of_newsletter
        /
) {
    column $col => {
        data_type => 'boolean',
        nullable => 0,
        default => 0,
    };
}

column updated_date => {
    data_type => 'datetime',
    is_nullable => 1,
    set_on_update => 1,
};

belongs_to user => 'DoES::Register::Schema::Result::User' => 'user_id';

1;

