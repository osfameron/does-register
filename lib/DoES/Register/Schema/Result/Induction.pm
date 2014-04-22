package DoES::Register::Schema::Result::Induction;

use DoES::Register::Schema::Candy
    -base => 'BaseObject';

column member_id => {
    data_type => 'int',
};

column sent_to_email => {
    data_type => 'varchar',
    size => 255,
};

column first_name => {
    data_type => 'varchar',
    size => 255,
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
        default => 0,
    };
}

belongs_to member => 'DoES::Register::Schema::Result::Member' => 'member_id';

subclass;
1;

