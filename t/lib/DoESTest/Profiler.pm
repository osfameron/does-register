package DoESTest::Profiler;
use Moo;
use MooX::HandlesVia;
use Time::HiRes;

extends 'DBIx::Class::Storage::Statistics';

has start => (
    is => 'rw',
);

has calls => (
    is => 'lazy',
    default => sub { [] },
    handles_via => 'Array',
    handles => {
        all_calls => 'elements',
        add_call  => 'push',
        call_count => 'count',
    },
);

sub print { } # silence logging

sub query_start {
    my $self = shift();
    my $sql = shift();
    my @params = @_;

    $self->start( time() );
}
 
sub query_end {
    my $self = shift();
    my $sql = shift();
    my @params = @_;
 
    my $elapsed = time() - $self->start;

    $self->add_call({
        sql => $sql,
        params => \@params,
        elapsed => $elapsed
    });
}

1;
