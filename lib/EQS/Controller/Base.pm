package EQS::Controller::Base;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $c = shift;

  my $tables = $c->app->dbh->selectcol_arrayref("show tables")
      or return $c->app->error($c, 400, [dbError => $DBI::errstr]);
  $c->render(
      msg     => 'Simple (too simple) MySQL table explorer',
      tables  => $tables,
  );
}

1;
