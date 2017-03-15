#!/usr/bin/perl -w

#Oggetto per la gestione delle risposte in un auxil
package Answers;

#librerie
use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use DateTime;
use XML::LibXML;
use Encode;
use FindBin qw($Bin);
use lib "$Bin/model";
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

my $retreiveAnswers = sub{
  my ($admin,$query,$id)=@_;
  my @risultati = $root->findnodes($query);
  my @messaggi;
  foreach (@risultati) {
    my %row=();
    $row{username} = $_->findnodes('./autore')->string_value();
    my $tdata=$_->findnodes('./data')->string_value();
    my ($date, $time)=split("T", $tdata);
    my ($year,$month,$day)=split("-",$date);
    $row{data} = $day."/".$month."/".$year;
    $row{idata} = $tdata;
    $row{hour} = $time;
    $row{text} = &ComFunc::cleanText($_->findnodes('./testo')->string_value());
    $row{admin} = $admin;
    $row{id} = $id;
    push(@messaggi, \%row);
  }
  return \@messaggi;
};

sub insertAnswer{
  my ($self,$id,$text,$username)=@_;
  my $date = DateTime->now();
  $text = Encode::encode_utf8($text);
  $date->set_time_zone( 'Europe/Rome' );
  my $data=$date->ymd()."T".$date->hms();
  if($text eq ""){
    return "ins=false";
  }
  elsif(length(Encode::encode_utf8($text))  > 200){
    return "ins=long";
  }
  else{
    my $ele = "\n<risposta>\n <testo>$text</testo>\n <autore>$username</autore>\n <data>$data</data>\n</risposta>";
    my $answer = $parser->parse_balanced_chunk($ele) || die ("Frammento non ben formato");
    my $parentAswers = $root->findnodes("//auxil[./id=\"$id\"]/risposte");
    $parentAswers->get_node(1)->appendChild($answer) || die("non riesco a trovare il padre");;
    open(OUT, ">$auxils");
    print OUT $doc->toString;
    close(OUT);
    return "";
 }
}


sub removeAnswer{
  my ($self,$id,$admin,$username,$data)=@_;
  my $mess="";
  if($admin == 1){
    my $query = "auxil[id=\"$id\"]/risposte/risposta[autore=\"$username\" and data=\"$data\"]";
    #verifico l'esistenza del nodo(per problemi di refresh)
    my $exist = $root->exists($query);
    if ($exist == 1) {
      my $answer = $root->findnodes($query)->get_node(1);
      my $parent = $answer->parentNode();
      my $deletedNode = $parent->removeChild($answer);
      open(OUT, ">$auxils");
      print OUT $doc->toString;
      close(OUT);
    }
    else{
      $mess="rm=false";
    }
  }
  return $mess;
}

# - Recupero delle risposte
sub getFirstAnswers{
    my ($self,$admin,$id)=@_;
    my $answers=$root->findnodes("//auxil[./id=\"$id\"]/risposte/risposta");
    my $numberAnswers = $answers->size();
    my $position = $numberAnswers - 10;
    return $retreiveAnswers->($admin,"//auxil[./id=\"$id\"]/risposte/risposta[position() > $position]",$id);
}
sub getAnswers{
    my ($self,$admin,$id)=@_;
    return $retreiveAnswers->($admin,"//auxil[./id=\"$id\"]/risposte/risposta",$id);
}
1;
