#!/usr/bin/env perl

use strict;
use Scalar::Util qw(looks_like_number);
use Data::Dumper;

my $DEBUG = 0;

# file name could be passed from args
my $data_file_name = $ARGV[0] || "task2.data";

# open will die if there are some probs reading file, anyway lets double check
die sprintf "No access to file: %s", $data_file_name unless -r $data_file_name;

my %numbers;

# Memory issue NOTE:
# Input file can contain for example just two lines with two numbers: Pi and E,
# both having 10^10^10 digits after the .
# It will be valid input file but it will requere not trivial handling.
# So assuming there is no edge cases for file/line length, but ready
# to provide possible solution for unusual cases too: 
# using `read` to buffer with defined input buffer size,
# using Devel::Size to control memory usage for working arrays
# and trying to catch ENOMEM error while sorting
open my $fh, '<', $data_file_name or die $!; # possible to use autodie pragma for open/close issues 
while (my $line = <$fh>) {
    my @elements = split ' ', $line;
    for my $n (@elements) {  # here - `for` is the same as `foreach`
        printf "%-10s : %s %s\n", $n,
            is_number($n)         ? "NUM" : "___",
            looks_like_number($n) ? "NUM" : "___"
                if $DEBUG;
        next unless looks_like_number($n); # using this 'cos Scalar::Util is a part of the Core Modules
        my $dn = 0 + $n;
        my $ce = $numbers{$dn} || [];
        push @$ce, $n;
        $numbers{$dn} = $ce;
    }
}
close $fh or die $!;

print Dumper \%numbers if $DEBUG;

# what to do with NaN and Inf?
# removing NaN (not a number, heh?)
delete $numbers{NaN};

local $" = $/;
print "@{[map {sort @{$numbers{$_}}} sort {$a <=> $b} keys %numbers]}";
print $/;

# one of the possible alternative to `looks_like_number`
# uses perl warning to detect numbers
sub is_number2 {
  my $n = shift;
  my $ret = 1;
  local $SIG{"__WARN__"} = sub {$ret = 0};
  eval { my $x = $n + 1 };
  return $ret
}
