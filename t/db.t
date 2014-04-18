use strict; use warnings;
use Test::Most;
use feature 'say';

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

use DoESTest;

my $app = DoESTest->new;

my $db = $app->db;

is $db->resultset('MembershipType')->count, 8;
is $db->resultset('User')->count, 3;
is $db->resultset('Membership')->count, 4;

my $user_rs = $db->resultset('User');
my $user_a = $user_rs->find({ name => 'Alice' });
ok $user_a, 'Alice retrieved' and do {
    ok $user_a->cake, 'Alice has had cake day';
};

my $user_b = $user_rs->find({ name => 'Bob' });
ok $user_b, 'Bob retrieved' and do {
    ok ! $user_b->cake, 'Bob has not had cake day';
};

my $user_c = $user_rs->find({ name => 'Colin' });
ok $user_c, 'Colin retrieved' and do {
    ok ! $user_c->cake, 'Colin has not had cake day';
};

done_testing;
