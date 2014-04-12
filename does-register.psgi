# use strict; use warnings;

use PocketIO;

use Plack::App::File;
use Plack::Builder;
use Plack::Middleware::Static;
use Plack::Response;

use Path::Tiny 'path';

use lib 'lib';
use DoES::Register;

use FindBin;
my $root = path( $FindBin::Bin );

sub mount_file {
    mount $_[0] => 
        Plack::App::File->new( 
            file => $root->child($_[1]) 
        )->to_app;
};

my $app = DoES::Register->new;

builder {
    mount_file '/socket.io/socket.io.js' 
        => '/public/socket.io.js';
    mount_file '/socket.io/static/flashsocket/WebSocketMain.swf' 
        => '/public/WebSocketMain.swf';
    mount_file '/socket.io/static/flashsocket/WebSocketMainInsecure.swf' 
        => '/public/WebSocketMainInsecure.swf';

    mount '/socket.io' => $app->pocket_io;

    mount '/' => builder {
        enable "Static",
            path => qr/\.(?:js|css|jpe?g|gif|png|html?|swf|ico)$/,
                root => $root->child('/public/');

        enable "SimpleLogger", level => 'debug';

        mount_file '/' => '/public/index.html';
    };

};
