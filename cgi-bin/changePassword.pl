#!/usr/bin/perl -w
use strict;
use diagnostics;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use model::user::User;
use presenter::Presenter;
use model::ComFunc;
use model::user::ModifyUser;

my $cgi = CGI->new();
my $session = CGI::Session->load();
my $modifier = new ModifyUser($session->param('username'));
my $user = new User($session->param('username'));
my $npass = $cgi->param('password');
my $cpass = $cgi->param('cpassword');
my $mess=0;
my $existPass=$user->checkPassword($cgi->param('opassword'));
if($existPass == 0 ){
	$mess = "4";
}
else{
	my $t_mess = $modifier->modifyPassword($npass,$cpass);
	$mess = "$t_mess";
}
my $sito ="cambio-password.cgi?state=".$mess;
print $cgi->redirect($sito);
