package DoES::Register::Management::Cmd::Test;

use Moo;
use MooX::Cmd;
use MooX::Options protect_argv => 0;

option use_main_db => (
    is => 'ro',
    doc => 'Use main db instead of deploying temporary one',
);

has test_app => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        $self->command_chain->[0]->test_app;
    },
);

sub execute {
    my ( $self, $args ) = @_;

    local $ENV{DOES_TEST_DSN} = $self->test_app->app_dsn if $self->use_main_db;

    if (@$args and -f $args->[-1]) {
        # oddly -t STDOUT is suppressed at some point in exec'd test, so
        # we override for Test::Pretty's benefit
        $ENV{PERL_TEST_PRETTY_ENABLED}++; 
        
        system( 'perl',
            # '-MTest::Pretty', # run pretty tests (broken subtest behaviour)
            '-Ilib',          # add ./lib
            '-It/lib',        # add ./t/lib
            @$args,
        );
    }
    else {
        # TODO: use App::ForkProve (but gives odd test failures)
        # $ENV{PERL_FORKPROVE_IGNORE} = 'no-preload';
        use App::Prove;
        my $ap = App::Prove->new;

        $ap->process_args(
            '-l',           # add ./lib
            '-It/lib',      # add ./t/lib
            # '-MPreload',    # pre-load common modules for speed
            '-r',           # run recursively
            @ARGV,
        );
        $ap->run;
    }
}

1;
