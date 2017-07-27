#!/usr/bin/env perl
#===============================================================================
#
#         FILE: server.pl
#
#        USAGE: ./server1.pl  daemon --listen http://0.0.0.0:8080
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: Mojolicious
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Danny Bud
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 19/07/17 13:11:25
#     REVISION: ---
#===============================================================================

use Mojolicious::Lite;
use strict;
use warnings;
use utf8;

my %prefixes;

get '/ping' => sub {
  my $c = shift;
  $c->render(text => "OK\n");
};


=pod 

=head2 test - The main wordfinder routine.
It is recursive over the length of the remaining letters.
If there are duplicate letters only the first needs to be tested at this level.

=head3 Input:

=over

=item prefix
The letters already used which are the prefix of one or more words.

=item unused
The letters not already used to make the prefixa. The letters must be sorted.

=back

=head3 Output:

A list of the words which can be formed with the given prefix and letters.

The algorithm ensures that unique words are generated.

=cut



sub test{
  my ($pref,$unused) = @_;
  my @result;

  my $letter="";
  for (0..$#$unused){
    next if $letter eq $unused->[$_];
    $letter = $unused->[$_];
    next if ! exists $prefixes{$pref.$letter};
    my $res = $prefixes{$pref.$letter};
    push @result,$pref.$letter if $res > 1;
    push @result, test($pref.$letter, [@{$unused}[0..($_-1),($_+1)..$#$unused]])
      if ($res & 1)  and $#$unused>0;
  }
  return @result;
}


get '/wordfinder/:word' => sub {
  my $c = shift;
  my @letters = sort split(//,$c->stash("word"));
  $c->render(json => [test("",\@letters)]);
};

=pod

=head2 add - Create the words/prefixes hash

The prefixes hash has an entry for each word or prefix of a word in the list past in.

The value of the entry in the hash is 

=over

=item  1 if this is the prefix of a word.

=item  2 if this is a word.

=item  3 if this is the prefix of a word and a word.

=back

=cut

sub add {
  my ($wordlist) = @_;
  for my $word (@$wordlist){
    $prefixes{$word} |= 2;
    for (0..(length($word)-2)){
      $prefixes{substr($word,0,$_)} |= 1;
    }
  }
}

####################### INITIALIZATION ######################################
my @wordlist = `grep  -e "^[a-z]\\+\$" /usr/share/dict/words`;
chomp @wordlist;
add(\@wordlist);

app->start;
