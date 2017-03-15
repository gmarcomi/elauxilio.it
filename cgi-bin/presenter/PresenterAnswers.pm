#oggetto container per oggetti Presenter, permettono la gestione dei commenti

#!/usr/bin/perl -w
package PresenterAnswers;
use HTML::Template;
use FindBin qw($Bin);
use lib "$Bin/presenter";
use Presenter;

my $presenter,$answers;

sub new {
  my ($class,$page,$tLogged,$tULogin,$tUsername,$tArea) = @_;
  my $self = {};
  $presenter = new Presenter($page,$tLogged,$tULogin,$tUsername,$tArea);
  $answers = $tLoginFolder."presenter/view/common/answers.tmpl";
  bless $self, $class;
  return $self;
}

sub initTemplate{
  my ($self) = @_;
  return $presenter->initTemplate();
}

sub assembleTemplate{
  my ($self,$template)=@_;
  $template->param(answers => qq/<TMPL_INCLUDE name = "$answers">/);
  my $compl = $presenter->assembleTemplate($template);
  return $compl;
}

sub renderTemplate{
  my ($self,$template)=@_;
  $presenter->renderTemplate($template);
}
1;
