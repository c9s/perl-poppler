#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use ExtUtils::testlib;

use Poppler;
use Data::Dumper::Simple;
use Cwd;

my $path = 'file://' . getcwd() . '/test.pdf';
# my $path = 'file:///Users/c9s/git-working/perl-poppler/perlxs.pdf';
my $o = Poppler::Document->new_from_file($path);
warn Dumper( $o );

$o->save('file:///tmp/test.pdf');

my @attaches = $o->get_attachments;
warn Dumper( @attaches );

my $page = $o->get_page( 0 );
warn Dumper( $page );

my $dimension = $page->get_size;
warn Dumper( $dimension );

warn $dimension->get_width;

use Cairo;
my $surface = Cairo::ImageSurface->create ('argb32', 100, 100);
my $cr = Cairo::Context->create ($surface);
$cr->rectangle (10, 10, 40, 40);
$cr->set_source_rgb (0, 0, 0);
$cr->fill;
$cr->rectangle (50, 50, 40, 40);
$cr->set_source_rgb (1, 1, 1);
$cr->fill;
$page->render_to_cairo( $cr );
$cr->show_page;
$surface->write_to_png ('output.png');


# XXX: render_to_cairo test

__END__

