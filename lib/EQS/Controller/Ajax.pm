package EQS::Controller::Ajax;
use Mojo::Base 'Mojolicious::Controller';

sub table_info {
  my $c          = shift;
  my $table_name = $c->stash('table_name');

  $table_name =~ s/[^\d\D_]+//g;

  my $row_count = $c->app->dbh->selectcol_arrayref("select count(*) from $table_name")
      or return $c->app->error($c, 400, [dbError => $DBI::errstr]);

  my $columns = $c->app->dbh->selectall_arrayref("show columns from $table_name")
      or return $c->app->error($c, 400, [dbError => $DBI::errstr]);

  my $fields = [];
  for my $f (@$columns) {
      push @$fields, $f->[0];
  }
  local $" = ', ';
  my $rows = $c->app->dbh->selectall_arrayref("select @$fields from $table_name limit 10")
      or return $c->app->error($c, 400, [dbError => $DBI::errstr]);


  $c->render(json => {
      table_name        => $table_name,
      row_count         => $row_count->[0],
      row_count_note    => $row_count->[0] > 10 ? 'showing only first 10 rows' : "",
      field_names       => $fields,
      rows              => $rows,
  });
}

1;
