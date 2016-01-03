#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use FindBin;
use PDF::Poppler;

chdir $FindBin::Bin;

require_ok ("PDF::Poppler");

my $fn1 = 'test.pdf';

ok (my $pdf = PDF::Poppler::Document->new_from_file($fn1),     "loaded new Document");
ok ($pdf->get_author   eq 'Jane Doe',          "author matched");
ok ($pdf->get_creator  eq 'John Doe',          "creator matched");
ok ($pdf->get_producer eq 'some-program',      "producer matched");
ok ($pdf->get_title    eq 'A Test Document',   "title matched");
ok ($pdf->get_subject  eq 'Testing',           "subject matched");
ok ($pdf->get_keywords eq 'test poppler perl', "keywords matched");
ok ($pdf->get_n_pages == 2,                    "page count matched");
ok (my $p1 = $pdf->get_page(0),                "fetched first page");
my ($w, $h) = $p1->get_size;
ok ($w == 288 && $h == 288,                    "dimensions matched");
my $rect = $p1->find_text('BAR');
ok (int($rect->x1) == 126,                     "text find x1 matched");
ok (int($rect->y2) == 48,                      "text find y2 matched");
ok (my $p2 = $pdf->get_page(1),                "fetched second page");
ok (! $p2->find_text('BAR'),                   "no match second page");
ok ($p2->find_text('BAZ'),                     "yes match second page");

done_testing();
exit;
