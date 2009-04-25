#!/usr/bin/env perl
use warnings;
use utf8;

use ExtUtils::testlib;

use Poppler;

my $o = Poppler::Document::document_new_from_file("test");


__END__

