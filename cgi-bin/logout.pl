#!/usr/bin/perl -w

#script per l'operazione di logout

use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;

my $cgi = CGI->new();
my $session = CGI::Session->load() or die $!;
my $SID = $session->id();
$session->close();
$session->delete();
$session->flush();
print $cgi->redirect("../index.html");
