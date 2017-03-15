#!/usr/bin/perl -w
#oggetto necessario per la presentazione dei dati su template
package Presenter;

#librerie
use HTML::Template;
#variabili private
my $content,$logged, $username,$login,$footer,$area,$uLogin;

sub new {
  my ($class,$page,$tLogged,$tULogin,$tUsername,$tArea) = @_;
  my $self = {};
  $username = "";
  $logged = 0 ;
  $area = 0;
  $uLogin = "none";
  $content = "presenter/view/pages/".$page;
  $logged = $tLogged if defined($tLogged);
  $username = $tUsername if defined($tUsername);
  $area = $tArea if defined($tArea);
  $uLogin = $tULogin if defined($tULogin);
  $login = "presenter/view/common/login.tmpl";
  $footer = "presenter/view/common/footer.tmpl";
  bless $self, $class;
  return $self;
}

sub initTemplate{
  my ($self) = @_;
  my $tempF = HTML::Template->new(filename=>$content);
  return $tempF;
}

sub assembleTemplate{
  my ($self,$template)=@_;
  $template->param(login => qq/<TMPL_INCLUDE name = "$login">/);
  $template->param(footer => qq/<TMPL_INCLUDE name = "$footer">/);
  my $compl = new  HTML::Template( scalarref => \$template->output(),
                                   ENCODING => 'utf8' );
  return $compl;
}

sub renderTemplate{
  my ($self,$template)=@_;
  if ($logged == 1){
    $template->param(logged => $logged);
    $template->param(username => $username);
    $template->param(area => $area);
  }
  else{
    if($uLogin eq "login"){
      $template->param(login => 1);
      $template->param(register => 0);
      $template->param(none => 0);
    }
    elsif($uLogin eq "register"){
      $template->param(login => 0);
      $template->param(register => 1);
      $template->param(none => 0);
    }
    elsif($uLogin == "none"){
      $template->param(login => 0);
      $template->param(register => 0);
      $template->param(none => 1);
    }
  }
  HTML::Template->config(utf8 => 1);
  print "Content-Type: text/html\n\n", $template->output;
}
1;
