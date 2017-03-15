#!/usr/bin/perl -w
use strict;
use diagnostics;
use CGI ;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use presenter::Presenter;
use model::user::Register;

my $cgi = CGI->new();
my $submitted = $cgi->param('submitted');

if($submitted == 1) {
  my $username=$cgi->param('username');
  my $nome = $cgi->param('name');
  my $cognome = $cgi->param('last');
  my $password = $cgi->param('password');
  my $reg = new Register($username,$nome,$cognome,$password);
  my $error = $reg->insert();
  if ($error eq "") {
    my $session = CGI::Session->new();
    $session->param("username", $username);
    print $session->header(-location => "index.cgi");
  }
  else{
    my $presenter= new Presenter("registrazione.tmpl",0,"register");
    my $pre=$presenter->initTemplate();
    $pre->param(info => $error);
    $pre->param(username => $username);
    $pre->param(name => $nome);
    $pre->param(last => $cognome);
    my $view = $presenter->assembleTemplate($pre);
    $presenter->renderTemplate($view);
  }
}
else{
  my $presenter= new Presenter("registrazione.tmpl",0,"register");
  my $pre=$presenter->initTemplate();
  my $view = $presenter->assembleTemplate($pre);
  $presenter->renderTemplate($view);
}
