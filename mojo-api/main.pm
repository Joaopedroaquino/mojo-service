#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

get '/hello-world' => sub ($c) {
  $c->render(template => 'index');
};

get '/' => sub ($c) {
  $c->render(template => 'index');
};

app->start;
__DATA__


@@ index.html.ep
% layout 'default';
% title 'Hello World';
<h1>Hello World with mojo <3!</h1>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

