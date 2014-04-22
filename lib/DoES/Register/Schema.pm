package DoES::Register::Schema;

use strict; use warnings;
use Class::Method::Modifiers;

use base 'DBIx::Class::Schema';

our $VERSION = 1;

__PACKAGE__->load_namespaces;

around deploy => sub {
    my ($orig, $self, @args) = @_;
    $self->$orig(@args);
    $self->setup_db;
};

sub setup_db {
    my $self = shift;

    my $type_rs = $self->resultset('MembershipType');
    $type_rs->create({ name => 'orga' });
    $type_rs->create({ name => 'tech',     unlimited => 1 }); # technician, interns etc.
    $type_rs->create({ name => 'service',  unlimited => 1 }); # cleaner, etc.
    $type_rs->create({ name => 'perm',     unlimited => 1 });
    $type_rs->create({ name => 'workshop', unlimited => 1 });
    $type_rs->create({ name => 'payg' });
    $type_rs->create({ name => 'friend' });
    $type_rs->create({ name => 'fwb' });

    my $usage_rs = $self->resultset('Usage');
    $usage_rs->create({ days_used => 0.00 });
    $usage_rs->create({ days_used => 0.25, cutoff => '18:00', max_hours => 3 });
    $usage_rs->create({ days_used => 0.50, cutoff => '12:00', max_hours => 6 });
    $usage_rs->create({ days_used => 1.00, min_hours => 4 });
}

1;
