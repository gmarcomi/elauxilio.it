#!/usr/bin/perl -w

#librerie
use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use DateTime;
use URI::URL;
use model::auxils::Answers;
use model::user::User;
use model::ComFunc;

my $cgi= new CGI;
my $session = CGI::Session->load();
my $sessionName = $session->param('username');
my $user = new User($sessionName);
my $answers = new Answers();

#controllo query string da url precedente
my $buffer= $cgi->referer();

my $url = URI::URL->new($buffer);
my $site=$url->path;
if($buffer eq ""){
  print $cgi->redirect("index.cgi");
}
my %get=%{&ComFunc::cleanGet($url->query())};
if(! defined $get{'all'}){
  $site= $site."?all=false";
}
else {
  my $value = $get{'all'};
  $site= $site."?all=$value";
}
#Gestione operazione
if ($sessionName ne ""){
  my $admin = $user->isAdmin();
  my $operation=$cgi->param('operation');
  my $id = $cgi->param('id');
  my $username = $cgi->param('username');
  if ($operation eq "delete" && $admin == 1 ) {
    my $remove = $answers->removeAnswer($id,$admin,$username,$cgi->param('data'));
    if ($remove ne "") {
      $site=$site."&".$remove;
    }
  }
  elsif ( $operation eq "insert") {
    my $text = &ComFunc::cleanText($cgi->param('testo'));
    my $mess=$answers->insertAnswer($id,$text,$username);
    if ($mess ne "") {
      $site=$site."&".$mess;
    }
  }
}
print $cgi->redirect($site);
