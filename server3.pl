#!/usr/bin/env perl
#===============================================================================
#
#         FILE: server.pl
#
#        USAGE: ./server3.pl  daemon --listen http://0.0.0.0:8080
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: Mojolicious, prefix
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Danny Bud 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 19/07/17 13:11:25
#     REVISION: ---
#===============================================================================

use Mojolicious::Lite;
use lib ".";
use prefix;
use strict;
use warnings;
use utf8;

my $prefixes = new prefix();

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

=item pref
The letters already used which are the prefix of one or more words.

=item unused
The letters not already used to make the prefixa. The letters must be sorted.

=item prefixes
The tree of letters relevant to the prefix (parameter 1)

=back

=head3 Output:

A list of the words which can be formed with the given prefix and letters.

The algorithm ensures that unique words are generated.

=cut


sub test{
  my ($pref,$unused,$prefixes) = @_;
  my @result;

  my $letter="";
  for (0..$#$unused){
    next if $letter eq $unused->[$_];
    $letter = $unused->[$_];
    my $res = $prefixes->find($letter);
    next if ! $res;
    push @result,$pref.$letter if $res->isWord();
    push @result, test($pref.$letter, [@{$unused}[0..($_-1),($_+1)..$#$unused]], $res)
      if ($res->has_children())  and $#$unused>0;
  }
  return @result;
}


get '/wordfinder/:word' => sub {
  my $c = shift;
  my @letters = sort split(//,$c->stash("word"));
  $c->render(json => [test("",\@letters, $prefixes)]);
};

=pod

=head2 add - Create the words/prefixes tree

The prefixes tree has an entry for each letter of a word in the list passed in.
We insert all of the letters of each word and mark the last letter as creating the word.

=cut

sub add {
  my ($wordlist) = @_;
  for my $word (@$wordlist){
    my $p = $prefixes;
    for (split(//,substr($word,0,-1))){
      $p = $p->insert($_,0);
    }
    $p->insert(substr($word,-1,1),1);
  }
}

####################### INITIALIZATION ######################################
my @wordlist = `grep  -e "^[a-z]\\+\$" /usr/share/dict/words`;
chomp @wordlist;
add(\@wordlist);

app->start;
