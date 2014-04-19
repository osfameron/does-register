package DoES::Register::Schema::Candy;

use parent 'DBIx::Class::Candy';

sub base { 'DoES::Register::Schema::' . $_[1] }
sub autotable { 1 }

1;
