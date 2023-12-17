use utf8;

use Mojolicious::Lite;
use Mojo::JWT;

use experimental 'signatures';

my $payload = {id => 1, api_key => 'xyz0wasd7xklyekz677ayxy'};

helper 'jwt_encode' => sub ($c, $payload = {}) {
  return Mojo::JWT->new(claims => $payload, secret => 's3cr3t')->encode;
};

helper 'jwt_decode' => sub ($c, $jwt) {
  return Mojo::JWT->new(secret => 's3cr3t')->decode($jwt);
};

helper 'authenticated' => sub ($c) {
  my $jwt = $c->param('jwt');
  $jwt = $c->jwt_decode($jwt);
  return $jwt->{api_key} eq $payload->{api_key} ? 1 : 0;
};


post '/v1/login' => sub ($c) {
  my $email = $c->param('email');
  my $password = $c->param('password');

  # error
  unless($email eq 'joaopedro@test.com' && $password eq 'scrtpass27k') {
    return $c->render(
      json => {error => 'invalid_username_or_password'},
      status => 400
    )
  }

  return $c->render(
    json => {api_token => $c->jwt_encode($payload)},
    status => 200
  )
};


under sub($c) {
  my $jwt = $c->param('api_token') || '';
  $jwt = eval { $c->jwt_decode($jwt) };
  return 1 if $jwt && $jwt->{api_key} eq $payload->{api_key};

  # Not authenticated
  $c->render(
    json => { error => 'unauthenticated' },
    status => 401
  );
  return undef
};


get '/v1/dashboard' => sub ($c) {
  my $jwt = $c->param('api_token');
  return $c->render(
    json => { current_user => $c->jwt_decode($c->param('api_token')) },
    status => 200
  )
};

app->start