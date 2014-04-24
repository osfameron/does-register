package DoES::Register::Management::Cmd::RunServer;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

use feature 'say';
use Plack::Runner;

has runner => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        my $runner = Plack::Runner->new;
        $runner->parse_options(@{ $self->plackup_args });
        $runner;
    },
);

has plackup_args => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        my @args = @{ $self->command_args };
        push @args, '-Ilib';
        push @args, '-a' => $self->psgi;
        \@args;
    }
);

has psgi => (
    is => 'ro',
    default => 'does-register.psgi',
);

sub execute {
    my ( $self, $args ) = @_;

    system 'sass',
        '--update' => 'public/stylesheets';

    say <<EOF;
================================
Note this server will NOT restart 
=================================
(looks like plackup doesn't work with PocketIO and -r
https://github.com/vti/pocketio/issues/30
EOF

    $self->runner->run;
}

1;
