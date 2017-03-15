#!/usr/bin/perl -w
#Libreria di supporto al package lib
package ComFunc;

use strict;
use diagnostics;

sub cleanGet{
  my $buffer=shift;
  my @pairs = split(/&/, $buffer);
  my $pair;
  my %input = {};
  foreach $pair (@pairs) {
    my ($name, $value) = split(/=/, $pair);
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/g;
    $name =~ tr/+/ /;
    $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C",hex($1))/g;
    $input{$name} = $value;
  }
  return \%input;
}
my $substring = sub {
  my $text = shift;
  my $find = shift;
  my $replace = shift;
  my $pos = index($text, $find);
  while ( $pos > -1 ) {
    substr( $text, $pos, length( $find ), $replace );
    $pos = index( $text, $find, $pos + length( $replace ));
  }
  return $text;
};
sub cleanText {
  my $text = shift;
  $text = $substring->($text,'&','&amp;');
  $text = $substring->($text,'<','&lt;');
  $text = $substring->($text,'>','&gt;');
  $text =~ s/"/&quot;/sg;
  $text = $substring->($text,'enstart',"<span lang=\"en\">");
  $text = $substring->($text,'enend','</span>');
  return $text;
}
1;
