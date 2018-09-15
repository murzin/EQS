package EQS::Controller::Base;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $c = shift;

  my $tables = $c->app->dbh->selectcol_arrayref("show tables");
  $c->render(
      msg     => 'Simple (too simple) MySQL table explorer',
      tables  => $tables,
  );
}

1;
