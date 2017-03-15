#!/usr/bin/perl -w

use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use presenter::Presenter;
use Scalar::Util qw(looks_like_number);
use model::auxils::Auxils;
use model::ComFunc;

my ($presenter, $page);
my $buffer= $ENV{'QUERY_STRING'};
my %get=%{&ComFunc::cleanGet($buffer)};
my $session = CGI::Session->load();
my $user = $session->param('username');
if ($user ne ""){
    $presenter= new Presenter("index.tmpl",1,"none",$user,0);
}
else{
    $presenter= new Presenter("index.tmpl",0);
}
my $pre=$presenter->initTemplate();
my $auxils = new Auxils();
if (! defined $get{'page'}) {
  $page = 1;
}
else{
  $page = $get{'page'};
}
#normalizzazione valori query string
if(! looks_like_number($page)) {
  $page = 1;
}
$pre->param(articles => $auxils->getAuxils($page));
#generazione link "pagine"
my $rPages = $auxils->getRemainsAuxils($page);
if($rPages > 0){
  if($page == 1) {
    $pre->param(changePage => "<a class=\"change\" href=\"index.cgi?page=2\">Notizie più vecchie</a>");
  }
 else{
   my $prevs = $page-1;
   my $changers = "<a class=\"change\" href=\"index.cgi?page=$prevs\">Notizie più recenti</a>";
   my $post = $page+1;
   $changers = "<a class=\"change\" href=\"index.cgi?page=$post\">Notizie più vecchie</a>".$changers;
   $pre->param(changePage => $changers);
 }
}
#altrimenti uno
else{
  my $changers;
  if($page > 1){
    my $prevs = $page-1;
    $changers = "<a class=\"change\" href=\"index.cgi?page=$prevs\">Notizie più recenti</a>";
  }
  else{
    $changers="";
  }
  $pre->param(changePage => $changers);
}
my $view = $presenter->assembleTemplate($pre);
$presenter->renderTemplate($view);
