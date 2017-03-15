#!/usr/bin/perl -w

#Oggetto per il reperimento delle informazioni sugli articoli "auxils"
package Auxils;

#librerie
use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;
use FindBin qw($Bin);
use lib "$Bin/model";
use user::User;
use ComFunc;
#variabili private
my ($doc,$root,$parser);
my $auxils = "../data/auxils/auxils.xml";

sub new {
  my $class = shift;
  #init
  $parser = new XML::LibXML();
  $doc = $parser->parse_file($auxils) || die ("Operazione di parsificazione fallita");
  $root = $doc->getDocumentElement() || die ("Non accedo alla radice");
  #init campi oggetto
  my $self = {};
  bless $self, $class;
  return $self;
}
my $searchAuxils = sub{
  my $query = shift;
  my @results = $root->findnodes($query);
  my @auxils;
  foreach (@results) {
    my %row=();
    my $user = new User
    my $id = $_->findnodes('./id')->string_value();
    my $tTitle = &ComFunc::cleanText($_->findnodes('./titolo')->string_value());
    $row{desc} = &ComFunc::cleanText($_->findnodes('./descrizione')->string_value());
    my $tdata=$_->findnodes('./data')->string_value();
    my ($date, $time)=split("T", $tdata);
    my ($year,$month,$day)=split("-",$date);
    my $title = "<a href=\"$id.cgi\">$tTitle</a>";
    $row{title} = $title;
    my $dmy = $day."/".$month."/".$year;
    my $nAnswers = scalar(@{$_->findnodes(".//risposta")});
    if($nAnswers > 1){
      $nAnswers = $nAnswers." commenti";
    }
    else {
      $nAnswers = $nAnswers." commento";
    }
    my $author=$_->findnodes('./autore')->string_value();
    my $user = new User($author);
    my $auth = $user->getName()." ".$user->getLast();
    $row{sub} = "Autore: <span class=\"author\">$auth</span><span class=\"datetime\">$time  $dmy</span><span class=\"nanswers\">$nAnswers</span>";
    push(@auxils, \%row);
  }
  return \@auxils;
};

sub getRemainsAuxils{
  my ($self,$page,$topic) = @_;
  my $nAuxils;
  if (! defined $topic) {
    $nAuxils= scalar(@{$root->findnodes(".//auxil")});
  }
  else{
    $nAuxils= scalar(@{$root->findnodes(".//auxil[topic=\"$topic\"]")});
  }
  my $cPages = int($nAuxils / 4);
  my $rPages = $nAuxils % 4;
  if ($rPages > 0){
    $cPages++;
  }
  $cPages = $cPages - $page;
  return $cPages;
}

sub getAuxils{
  my ($self,$page) = @_;
  my $prev = ($page - 1) * 4;
  my $next = $page * 4;
  my $query="//auxil[position() <= $next and position() > $prev]";
  return $searchAuxils->($query);
}
1;
