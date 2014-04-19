package DoES::Register::Schema::Candy;

use parent 'DBIx::Class::Candy';

sub base { 'DoES::Register::Schema::' . $_[1] }

# I think the default plural table names are a bit annoying
sub autotable { 1 }
sub gen_table {
    my ($self, $class) = @_;
    my @parts = split /::/, $class;
    my $table = lc $parts[-1];
    $table =~s/^user$/users/;
    return $table;
}

1;
