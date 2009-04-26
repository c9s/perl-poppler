#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use ExtUtils::testlib;

use Poppler;

my $o = Poppler::Document->new_from_file("perlxs.pdf");

use Data::Dumper::Simple;
warn Dumper( $o );

__END__

