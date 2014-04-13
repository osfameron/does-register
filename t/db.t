use strict; use warnings;
use Test::Most;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

use DoESTest;

my $app = DoESTest->new;

my $db = $app->db;
is $db->resultset('Type')->count, 5;

done_testing;
