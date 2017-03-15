#Modulo oggetto per la registrazione di un utente in users.xml

#!/usr/bin/perl -w
package Register;

#librerie
use strict;
use diagnostics;
use DateTime;
use XML::LibXML;
use Digest::SHA qw(sha256_hex);
#variabili private
my ($username,$name,$last,$password);
my ($doc,$root,$username,$parser);
my $path = "../data/users/users.xml";

#costruttore
sub new {
  my $class = shift;
  #init
  $username = shift;
  $name = shift;
  $last = shift;
  $password = shift;
  $parser = new XML::LibXML();
  $doc = $parser->parse_file($path) || die ("Operazione di parsificazione fallita");
  $root = $doc->getDocumentElement() || die ("Non accedo alla radice");
  #init campi oggetto
  my $self = {};
  bless $self, $class;
  return $self;
}
#metodi privati
my $checkUsername = sub {
    my $error="";
    if ($username eq "") {
        $error= "<p>Campo <span lang=\"en\">username</span> obbligatorio</p>";
    }
    elsif (length($username) < 5){
        $error= "<p><span lang=\"en\">Username</span> minore di 5 caratteri</p>";
    }
    return $error;
};

my $checkName = sub {
    my $error="";
    if ($name eq ""){
        $error="<p>Campo nome obbligatorio</p>";
    }
    elsif($name !~ /[A-Z][a-zA-Z]*/){
        $error="<p>Nome non valido</p>";
    }
    return $error;
};

my $checkLastname = sub {
    my $error="";
    if ($last eq "") {
        $error="<p>Campo cognome obbligatorio</p>";
    }
    elsif($last !~ /[a-zA-z]+([ '-][a-zA-Z]+)*/){
        $error="<p>Cognome non valido</p>";
    }
    return $error;
};

my $checkPassword = sub {
    my $error = "";
    if ($password eq "") {
        $error = "<p>La nuova <span lang=\"en\">password</xml> non può essere vuota</p>";
    }
    elsif (length($password) < 5) {
        $error = "<p><span lang=\"en\">Password</span> troppo corta, sono necessari almeno 5 caratteri</p>";
    }
    return $error;
};

my $insertNewUser = sub{
  my ($pUser,$pName,$pLast,$pHpwd,$pHour,$pData)=@_;
  my $hashpwd = sha256_hex($password);
  $pUser = Encode::encode_utf8($pUser);
  $pName = Encode::encode_utf8($pName);
  $pLast = Encode::encode_utf8($pLast);
  my $ele = "<utente admin=\"no\">
               <username>$pUser</username>
               <nome>$pName</nome>
               <cognome>$pLast</cognome>
               <iscrizione>
                 <ora>$pHour</ora>
                 <data>$pData</data>
               </iscrizione>
               <password>$pHpwd</password>
             </utente>";
  my $frammento = $parser->parse_balanced_chunk($ele) || die("Frammento non ben formato");
  $root->appendChild($frammento) || die ("non riesco a trovare il padre");
  open(OUT, ">$path");
  print OUT $doc->toString;
  close(OUT);
};

#metodi pubblici
sub insert {
  my $self = shift;
  my $error = "";
  #generazioni stringhe errori
  my $userError = $checkUsername->();
  my $nameError = $checkName->();
  my $lastError = $checkLastname->();
  my $passError = $checkPassword->();
  $error = $error.$userError.$nameError.$lastError.$passError;
  #controllo errori
  if ($error eq "") {
    my $dt=DateTime->now();
    $dt->set_time_zone('Europe/Rome');
    my $data=$dt->ymd();
    my $hour=$dt->hms();
    my $hpwd = sha256_hex($password);
    $insertNewUser->($username,$name,$last,$hpwd,$hour,$data);
  }
  return $error;
}
1;
