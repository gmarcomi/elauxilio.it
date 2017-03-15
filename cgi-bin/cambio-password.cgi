#!/usr/bin/perl -w
use strict;
use diagnostics;

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use model::user::User;
use presenter::Presenter;
use model::ComFunc;

my $cgi = CGI->new();
my $session = CGI::Session->load();
my ($sessionName,$user);
if ($session->param('username')){
	$sessionName = $session->param('username');
	$user = new User($sessionName);
}
else {
	print $cgi->redirect("index.cgi");
}

my $presenter= new Presenter("cambio-password.tmpl",1,"none",$sessionName,1);
my $pre=$presenter->initTemplate();

my $comm;
my $buffer= $ENV{'QUERY_STRING'};
my %get=%{&ComFunc::cleanGet($buffer)};
if ($get{'state'} eq "0") {
	$comm = "<span lang=\"en\">Password</span> modificata corretamente";
}
elsif($get{'state'} eq "1"){
	$comm = "La nuova <span lang=\"en\">password</xml> non può essere vuota";
}
elsif($get{'state'} eq "2"){
	$comm = "<span lang=\"en\">Password</span> troppo corta, sono necessari almeno 5 caratteri";
}
elsif($get{'state'} eq "3"){
	$comm = "Le due <span lang=\"en\">password</span> non coincidono e/o la nuova <span lang=\"en\">password</xml> è vuota";
}
elsif($get{'state'} eq "4"){
	$comm="<span lang=\"en\">Password</span> vecchia errata";
}
$pre->param(info => $comm);
my $view = $presenter->assembleTemplate($pre);
$presenter->renderTemplate($view);
