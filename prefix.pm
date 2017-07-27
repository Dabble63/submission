package prefix;
#===============================================================================
#
#         FILE: prefix.pm
#
#        USAGE: 
#            use prefix;
#            $p = new prefix();
#            $p.insert(<letter>,<isWord>) returns the inserted element
#            $p.isWord()                  returns true if this is the last character in a word
#            $p.has_children()            returns true if this element has child elements.
#
#  DESCRIPTION: A tree element 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Danny Bud, 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 19/07/17 13:11:25
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

sub new {
  my ($proto, $isWord) =@_;
  my $class = ref($proto) || $proto;
  my $self={};
  bless ($self,$class);
  $self->{"letters"} = {};
  $self->{"isWord"} = $isWord;
  return $self;
}

sub insert {
  my ($self, $letter, $isWord) = @_;
  if (! exists $self->{"letters"}->{$letter}){
    $self->{"letters"}->{$letter} = $self->new($isWord);
  } else {
    $self->{"isWord"} |= $isWord;
  }
  return $self->{"letters"}->{$letter};
}

sub isWord{
  return shift->{"isWord"};
}

sub find{
  my ($self, $letter) = @_;
  return $self->{"letters"}->{$letter}
    if exists $self->{"letters"}->{$letter};
  return undef;
}

sub has_children {
  my ($self, $letter) = @_;
  return scalar($self->{"letters"})>0;
}
1;

__END__

=head1 NAME

prefix - Prefix tree element

=head1 SYNOPSIS

      use prefix;
            
      $p = new prefix();
      subtree = $p.insert("a",1)     # returns the inserted element
      $p.isWord()                    # returns true if this is the last character in a word
      $p.has_children()              # returns true if this element has child elements.

=head2 Functions

=over 4

=item new(<isword>)

creates a new tree element and sets the isword flag

=item insert(<letter>,<isword>)

creates a new tree element as a subelement of this element

Returns the new element.

=item isWord()

Returns true if this is the last character in a word

=item find(<letter>)

Returns the sub-element indexed by <letter> if it exists. 

Returns undef otherwise

=item has_children()

Returns true if this element has child elements.

=back

=cut`

