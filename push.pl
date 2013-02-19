#!/usr/bin/env perl

use strict;

system "git add .";
my $deleted = `git ls-files --deleted`;
unless ($deleted eq "") {
  my @deleted = split("\n",$deleted);
  for(my $i = 0; $i < @deleted; $i++) {
    system "git rm " . $deleted[$i];
  }
}
system "git commit -m " . $ARGV[0];
system "git push -u origin master";

#EOF
