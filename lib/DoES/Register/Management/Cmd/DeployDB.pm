package DoES::Register::Management::Cmd::DeployDB;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

use feature 'say';

use DoESTest;

option setup_fixtures => (
    is => 'ro',
    doc => 'use test fixtures to deployment',
);

sub execute {
    my ( $self, $args, $chain ) = @_;

    my $app = $chain->[0]->app;
    my $db = $app->db;
    $db->deploy;

    if ($self->setup_fixtures) {
        say 'Setting up fixtures';
        DoESTest->setup_fixtures($db);
        say 'You can run tests against this with:';
        say '    bin/manage test --use-main-db';
    }
}

1;
