#!/usr/bin/perl -w

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use model::user::User;
use presenter::Presenter;

my $cgi = new CGI;
my $username = $cgi->param('username');
my $password = $cgi->param('password');
my $user = new User("$username");
my $existUser=$user->exist();
my $existPass=$user->checkPassword($password);
my $errorQueryString="";
if ($existUser == 1 and $existPass==1) {
  my $session = CGI::Session->new();
  $session->param('username', $username);
  print $session->header(-location => "index.cgi");
}
else{
  my $presenter= new Presenter("login.tmpl",0,"login");
  my $pre=$presenter->initTemplate();
  if($username ne "" || $password ne ""){
    $pre->param(error_login => 1);
    $pre->param(username =>$username);
  }
  my $view = $presenter->assembleTemplate($pre);
  $presenter->renderTemplate($view);
}
