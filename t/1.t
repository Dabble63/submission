#!/usr/bin/env perl
#===============================================================================
#
#         FILE: t1.pl
#
#        USAGE: ./t1.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 23/07/17 08:45:55
#     REVISION: ---
#===============================================================================
use Test::More;
use Test::Mojo;

use strict;
use warnings;
use utf8;

require "server.pl";
my $t = Test::Mojo->new;

# HTML/XML
$t->get_ok('/ping')->status_is(200)->content_is("OK\n");
$t->get_ok('/wordfinder/gdo')->status_is(200)->json_is(["do","dog","go","god","od"]);
$t->get_ok('/wordfinder/meme')->status_is(200)->json_is(["ee","em","eme","me","mee","mem","meme","mm"]);
$t->get_ok('/wordfinder/memememememmmmmeeeeeee')->status_is(200)->json_is(["ee","em","eme","me","mee","mem","meme","mm"]);


done_testing();
