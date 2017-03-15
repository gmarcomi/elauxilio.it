#!/usr/bin/perl -w
use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use model::auxils::Answers;
use model::ComFunc;
use model::user::User;
use presenter::PresenterAnswers;

my @info=();
my $cgi= new CGI;
my $session = CGI::Session->load();
my $sessionName = $session->param('username');
my $user = new User($sessionName);
my $presenter;
my $view;
my $admin=0;
my $logged=0;
# controllo sessione
if ($sessionName ne ""){
    $presenter= new Presenter("info.tmpl",1,"none",$sessionName,0);
    $logged=1;
    $admin = $user->isAdmin();
}
else{
    $presenter= new Presenter("info.tmpl",0,"none");
}

my $initT = $presenter->initTemplate();
my $view = $presenter->assembleTemplate($initT);
$presenter->renderTemplate($view);
