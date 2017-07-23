#!/usr/bin/env perl
#===============================================================================
#
#         FILE: server.pl
#
#        USAGE: ./server.pl  daemon --listen http://0.0.0.0:8080
#
#  DESCRIPTION: This is a demonstration web server.
#
#      OPTIONS: ---
# REQUIREMENTS: Mojolicious, Tree::Trie
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Danny Bud 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 23/07/17 13:11:25
#     REVISION: ---
#===============================================================================

use Mojolicious::Lite;
use Tree::Trie;
use strict;
use warnings;
use utf8;

my($trie) = new Tree::Trie;

get '/ping' => sub {
  my $c = shift;
  $c->render(text => "OK\n");
};

=pod 

=head2 The main wordfinder routine.
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
    next if $letter eq $unused->[$_]; # Ignore duplicates 
    $letter = $unused->[$_];
    my $res = $trie->lookup($pref.$letter); # Is this the prefix of a word?
    push @result,$res                       # Add the word if we found it in the tie.
      if defined $res && ($res eq $pref.$letter);
    # Recurse with the remaining letters if this is a prefix and there are more letters.
    push @result, test($pref.$letter, [@{$unused}[0..($_-1),($_+1)..$#$unused]])
      if defined $res and $#$unused>0;
  }
  return @result;
}


get '/wordfinder/:word' => sub {
  my $c = shift;
  my @letters = sort split(//,$c->stash("word"));
  $c->render(json => [test("",\@letters)]);
};

####################### INITIALIZATION ######################################
my @wordlist = `grep  -e "^[a-z]\\+\$" /usr/share/dict/words`;
chomp @wordlist;
$trie->add(@wordlist);

app->start;
