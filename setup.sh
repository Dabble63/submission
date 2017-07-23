#!/bin/sh
apk --no-cache add perl
apk --no-cache add perl-mojolicious
apk --no-cache add perl-test-pod
apk --no-cache add perl-test-pod-coverage
apk --no-cache add make
perl -MCPAN -e"install Tree::Trie"
mkdir -p /usr/share/dict
mv /app/sowpods.txt /usr/share/dict/words
