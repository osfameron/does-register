use strict; use warnings;
use Test::Most;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

use DoESTest;

my $app = DoESTest->new;

warn $app->dsn;

my $db = $app->db;

$db->resultset('Type')->create({ name => 'orga' });
$db->resultset('Type')->create({ name => 'perm', unlimited => 1 });
$db->resultset('Type')->create({ name => 'ws', unlimited => 1 });
$db->resultset('Type')->create({ name => 'friend' });
$db->resultset('Type')->create({ name => 'fwb' });

is $db->resultset('Type')->count, 5;

done_testing;
