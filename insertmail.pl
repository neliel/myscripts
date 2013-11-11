#!/usr/bin/env perl

## insertmail.pl
## 19.05.2013

use strict;
use warnings;

use DBI;
use MIME::Base64;

sub getPipe
  {
    my $file;
    while (<>)
      {
	$file .= $_;
      }
    return $file;
  }

sub getFrom
  {
    my ($res, $garb) = $_[0] =~ /From:(.+@.+\.(fr|com|eu|org|net).?)/;
    return $res;
  }

sub getTo
  {
    my ($res, $garb) = $_[0] =~ /To:(.+@.+\.(fr|com|eu|org|net).?)/;
    return $res;
  }

sub getSubject
  {
    my ($res) = $_[0] =~ /Subject:(.+)/;
    return $res;
  }

sub makeTransact
    {
      # setting up all the variables
      my $dbPath  = $_[0];
      my $file    = $_[1];
      my $dest    = getTo($file);
      my $exped   = getFrom($file);
      my $subject = getSubject($file);

      # connecting to the database
      my $dbh = DBI->connect( "dbi:SQLite:$dbPath" ) || die "Cannot connect: $DBI::errstr";

      # checking if the dest entry exist and if not insering it
      my $sth   = $dbh->prepare("SELECT d_id FROM dest WHERE maildest LIKE \'$dest\'");
      $sth->execute();
      my $did   = $sth->fetchrow();
      $sth->finish();
      unless ($did //= "")
	{
	  $dbh->do("INSERT INTO dest(maildest) VALUES(\'$dest\')");
	}

      # checking if the exped entry exist and if not insering it
      my $sth2  = $dbh->prepare("SELECT e_id FROM exped WHERE mailexped LIKE \'$exped\'");
      $sth2->execute();
      my $eid   = $sth2->fetchrow();
      $sth2->finish();
      unless ($eid //= "")
	{
	  $dbh->do("INSERT INTO exped(mailexped) VALUES(\'$exped\')");
	}

      # getting the id of the dest
      my $sth3   = $dbh->prepare("SELECT d_id FROM dest WHERE maildest LIKE \'$dest\'");
      $sth3->execute();
      my $did2   = $sth3->fetchrow();
      $sth3->finish();

      # getting the id of the exped
      my $sth4   = $dbh->prepare("SELECT e_id FROM exped WHERE mailexped LIKE \'$exped\'");
      $sth4->execute();
      my $eid2   = $sth4->fetchrow();
      $sth4->finish();

      # insering the mail (with the headers so that I can read it with mutt later)
      # he email is stored as base64 string as it caused error uon insertion
      $dbh->do("INSERT INTO mails(d_id, e_id, sujet, mail) VALUES ($did2, $eid2, \'$subject\', \'" . encode_base64($file)  . "\')");

      $dbh->disconnect()
    }

##################### MAIN #####################

my $file   = getPipe();
my $dbPath = "/home/sarfraz/Documents/backup/bmsg.db";
makeTransact($dbPath, $file);
exit 0;

################################################

#eof
