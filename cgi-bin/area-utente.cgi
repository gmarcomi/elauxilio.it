#!/usr/bin/perl -w
use strict;
use diagnostics;

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use model::user::User;
use presenter::Presenter;

my $cgi = CGI->new();
my $session = CGI::Session->load();
my ($sessionName,$user);
if ($session->param('username')) {
	$sessionName = $session->param('username');
	$user = new User($sessionName);
}
else {
	print $cgi->redirect("index.cgi");
}
my $presenter= new Presenter("area-utente.tmpl",1,"none",$sessionName,1);
my $pre=$presenter->initTemplate();

my $admin= $user->isAdmin();
$pre->param(username => $sessionName);
$pre->param(name => $user->getName());
$pre->param(last => $user->getLast());
$pre->param(iscrizione => $user->getDate());
my $view = $presenter->assembleTemplate($pre);
$presenter->renderTemplate($view);
