#!/usr/bin/env perl

  use strict;
  use DBI;

  my $data_source = sprintf "DBI:mysql:database=EQS;host=localhost;port=3306";
  my $dbh = DBI->connect($data_source, 'eqs', 'eqs') or die $DBI::errstr;
  my $rows = $dbh->selectall_arrayref("select dept_no, dept_name from departments") or die $DBI::errstr;
  for my $r (@$rows) {
      printf "Dep ID: %10s, Dept Name: %s\n", @$r;
  }
  $dbh->disconnect;
