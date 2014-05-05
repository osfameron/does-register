package DoES::Register::Twitter;

use Moo;
use Net::Twitter;
use JSON;
use Path::Tiny;
use MooX::HandlesVia;
use Plack::Request;

has config_root => (
    is => 'ro',
);

has net_twitter => (
    is => 'lazy',
    default => sub {
        my $self = shift;
        my $nt = Net::Twitter->new(
            traits          => ['API::RESTv1_1', 'OAuth'],
            ssl => 1,
            consumer_key    => $self->api_key,
            consumer_secret => $self->api_secret,
        );
        $nt->access_token($self->access_token) if $self->has_access_token;
        $nt->access_token_secret($self->access_token_secret) if $self->has_access_token_secret;
        return $nt;
    },
);

has api_credentials_file => (
    is => 'lazy',
    default => sub { shift->config_root->child('twitter_api_credentials.json') },
);

has api_credentials => (
    is => 'lazy',
    default => sub { decode_json( shift->api_credentials_file->slurp ) },
    handles_via => 'Hash',
    handles => {
        api_key             => [ 'get' => 'api_key' ],
        api_secret          => [ 'get' => 'api_secret' ],
        access_token        => [ 'get' => 'access_token' ],
        access_token_secret => [ 'get' => 'access_token_secret' ],
        has_access_token        => [ 'exists' => 'access_token' ],
        has_access_token_secret => [ 'exists' => 'access_token_secret' ],
    },
);

sub image_for_user {
    my ($self, $screen_name) = @_;
    my $net_twitter = $self->net_twitter;
    return unless $net_twitter->authorized;
    my $user = $net_twitter->show_user({ screen_name => $screen_name });
    return $user->{profile_image_url};
}

1;
