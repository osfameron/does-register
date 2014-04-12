# use strict; use warnings;

use PocketIO;

use Plack::App::File;
use Plack::Builder;
use Plack::Middleware::Static;
use Plack::Response;

use Path::Tiny 'path';

use FindBin;

my $root = path( $FindBin::Bin );

builder {
    mount '/socket.io/socket.io.js' => 
        Plack::App::File->new( 
            file => $root->child('/public/socket.io.js')
        )->to_app;

    mount '/socket.io/static/flashsocket/WebSocketMain.swf' =>
          Plack::App::File->new(file => $root->child('/public/WebSocketMain.swf')
          )->to_app;

    mount '/socket.io/static/flashsocket/WebSocketMainInsecure.swf' =>
          Plack::App::File->new(file => $root->child('/public/WebSocketMainInsecure.swf')
          )->to_app;

    mount '/socket.io' => PocketIO->new(
        handler => sub {
            my $self = shift;

            $self->on( message => sub {
                warn join ',' => @_;
            });

            $self->on( hello => sub {
                    my ($self, $fun) = @_;

                    $self->emit( members => ['TODO'] );
                }
            );
        }
    );

    mount '/' => builder {
        enable "Static",
            path => qr/\.(?:js|css|jpe?g|gif|png|html?|swf|ico)$/,
                root => $root->child('/public/');

        enable "SimpleLogger", level => 'debug';

        sub {
            my $res = Plack::Response->new(200);
            $res->body( $root->child('/public/index.html')->slurp );
            $res->finalize;
        }
    };

};
