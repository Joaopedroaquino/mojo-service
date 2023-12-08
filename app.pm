use Mojolicious::Lite;


get '/'=> sub {
    my $c = shift;
    my @hw = ('hello','world');
    $c->render(json=> @hw[0]);
};


get '/hw'=> sub {
    my $c = shift;
    my @hw = ('hello','world');
    $c->render(json=> @hw[1]);


};


app->start;