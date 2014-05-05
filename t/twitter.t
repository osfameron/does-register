use strict; use warnings;
use feature 'say';

use Test::Most;
use Data::Dumper;

use DateTime;
use DoESTest;
use Plack::Test;

my $app = DoESTest->new;
my $twitter = $app->twitter;

plan skip_all => 'No api credentials for testing' unless $twitter->api_credentials_file->is_file;
my $net_twitter = $twitter->net_twitter;
plan skip_all => 'Twitter not authorized' unless $net_twitter->authorized;

diag $twitter->api_key;

my $image_url = $twitter->image_for_user('osfameron');
diag $image_url;

ok $image_url;
like $image_url, qr{^http://.*\.(png|jpg|gif)$};

done_testing;
