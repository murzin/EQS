package EQS;
use Mojo::Base 'Mojolicious';

use DBI;

sub startup {
  my $self = shift;

  my $config = $self->plugin('Config');
  my $log    = $self->log;

  $log->warn("Mojolicious Mode is " . $self->mode);
  $log->warn("Log Level        is " . $log->level);
  $log->warn("App Path         is " . $self->home);

  my $data_source = sprintf "DBI:mysql:database=%s;host=%s;port=%s", @$config{qw(mysql_db mysql_host mysql_port)};
  $self->{dbh} = DBI->connect($data_source, $config->{mysql_user}, $config->{mysql_password})
    or die $DBI::errstr;

  my $r = $self->routes;

  $r->get('/')->to('base#index');

  $r->get('/ajax/table/:table_name')->to('ajax#table_info');
}

sub dbh {
    my $self = shift;
    $self->{dbh} or die "dbh gone!"; # my be add reconnect or use DBIx::Connector later
}

sub error {
    my $self    = shift;
    my $c       = shift;
    my $code    = shift || 418;
    my $err_msg = shift || [unknownError => 'Unknown Error'];

    $self->log->error("Error: ".$err_msg->[0]." : ".$err_msg->[1]);
    $c->render(json   => {error_code => $err_msg->[0], error_text => $err_msg->[1]},
               status => $code);
}
1;
