#!/usr/bin/perl -w
package ModifyUser;
#librerie
use strict;
use diagnostics;
use XML::LibXML;
use Digest::SHA qw(sha256_hex);
#variabili private
my ($doc, $root, $username, $parser);
my $path = "../data/users/users.xml";

#costruttore
sub new {
  my $class = shift;
  #init
  $username = shift;
  $parser = XML::LibXML -> new();
  $doc = $parser->parse_file($path) || die ("Operazione di parsificazione fallita");
  $root = $doc->getDocumentElement() || die ("Non accedo alla radice");
  #init campi oggetto
  my $self = {};
  bless $self, $class;
  return $self;
}
my $checkNewPassword = sub{
  my $newpwd = shift;
  my $cnewpwd = shift;
  my $error = 0;
  if ($newpwd eq "") {
    $error = 1;
  }
  elsif (length($newpwd) < 5) {
    $error = 2;
  }
  elsif ($newpwd ne $cnewpwd) {
    $error= 3;
  }
  return $error;
};

sub modifyPassword{
  my $self = shift;
  my $newpwd = shift;
  my $cnewpwd = shift;
  my $error = $checkNewPassword->($newpwd,$cnewpwd);
  if($error == 0){
    my $hasp=sha256_hex("$newpwd");
    my $node = $root->findnodes("//utente[username=\"$username\"]/password/text()")->get_node(1);
    $node->setData($hasp);
    open(OUT, ">$path");
    print OUT $doc->toString;
    close(OUT);
  }
  return $error;
}
1;
