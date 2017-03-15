#Oggetto query per users.xml

#!/usr/bin/perl -w
package User;

#librerie
use strict;
use diagnostics;
use XML::LibXML;
use Digest::SHA qw(sha256_hex);
#variabili private
my $doc,my $root,my $username,my $parser;
my $path = "../data/users/users.xml";

#costruttore
sub new {
  my $class = shift;
  #init
  $username = shift;
  $parser = new XML::LibXML();
  $doc = $parser->parse_file($path) || die ("Operazione di parsificazione fallita");
  $root = $doc->getDocumentElement() || die ("Non accedo alla radice");
  #init campi oggetto
  my $self = {};
  bless $self, $class;
  return $self;
}

sub getName{
    my $self = shift;
    my $fpath="utente[username=\"$username\"]";
    return $root->findnodes($fpath."/nome/text()")->get_node(1)->toString;
}
sub getLast{
    my $self = shift;
    my $fpath="utente[username=\"$username\"]";
    return $root->findnodes($fpath."/cognome/text()")->get_node(1)->toString;
}
sub getDate{
    my $self = shift;
    my $fpath="utente[username=\"$username\"]";
    my $ora  = $root->findnodes($fpath."/iscrizione/ora/text()")->get_node(1)->toString;
    my $data = $root->findnodes($fpath."/iscrizione/data/text()")->get_node(1)->toString;
    my ($year,$month,$day)=split("-",$data);
    $data = $day."/".$month."/".$year;
    return $ora." ".$data;
}
sub exist{
    my $self = shift;
    my $fpath="utente[username=\"$username\"]";
    return $root->exists($fpath);
}
sub isAdmin{
    my $self = shift;
    return $root->exists("utente[username=\"$username\" and \@admin=\"si\"]");
}
sub checkPassword{
    my $self = shift;
    my $password = shift;
    my $h_pwd = sha256_hex($password);
    my $res=$root->exists("utente[username=\"$username\" and password=\"$h_pwd\"]");
    return $res;
}
1;
