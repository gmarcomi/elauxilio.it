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
    $presenter= new PresenterAnswers("ubuntu-15.10-guida-completare-installazione.tmpl",1,"none",$sessionName,0);
    $logged=1;
    $admin = $user->isAdmin();
}
else{
    $presenter= new PresenterAnswers("ubuntu-15.10-guida-completare-installazione.tmpl",0,"none");
}

my $initT = $presenter->initTemplate();
my $view = $presenter->assembleTemplate($initT);

#controllo query string
my $buffer= $ENV{'QUERY_STRING'};
my %get=%{&ComFunc::cleanGet($buffer)};
#controllo tipo di visualizzazione
$view->param(id => "ubuntu-15.10-guida-completare-installazione");
my $answers = new Answers();
$view->param(username => $sessionName);
if ($get{'all'} eq "true") {
  $view->param(answers => $answers->getAnswers($admin,"ubuntu-15.10-guida-completare-installazione"));
  $view->param(total => 1);
}
else{
  $view->param(answers => $answers->getFirstAnswers($admin,"ubuntu-15.10-guida-completare-installazione"));
  $view->param(total => 0);
}
#controllo presenza messaggi da parametri get
if ($get{'ins'} eq "false") {
    $view->param(enotify => 1);
    $view->param(info => "Impossibile inserire un messaggio vuoto");
}
elsif ($get{'ins'} eq "long") {
    $view->param(enotify => 1);
    $view->param(info => "Il messaggio supera i 200 caratteri permessi");
}
elsif ($get{'rm'} eq "false") {
    $view->param(enotify => 1);
    $view->param(info => "Impossibile eliminare il messaggio");
}
$presenter->renderTemplate($view);
