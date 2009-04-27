package Poppler;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( );

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Poppler', $VERSION);

# Preloaded methods go here.

1;
__END__

=head1 NAME

Poppler - perl binding of poppler library.

=head1 SYNOPSIS

    use Poppler;
    my $path = 'file:///path/to/some.pdf';

    my $o = Poppler::Document->new_from_file($path);

    my $page = $o->get_page( 0 );

    my $dimension = $page->get_size;

    warn $dimension->get_width;
    warn $dimension->get_height;

    # render to cairo
    use Cairo;
    my $surface = Cairo::ImageSurface->create ('argb32', 100, 100);
    my $cr = Cairo::Context->create ($surface);

    $page->render_to_cairo( $cr );

    $cr->show_page;
    $surface->write_to_png ('output.png');

__END__

=head1 DESCRIPTION


=head2 EXPORT

None by default.

=head1 SEE ALSO

github repository:

    http://github.com/c9s/perl-poppler/tree/master

poppler:

    http://poppler.freedesktop.org/

=head1 AUTHOR

Cornelius , C< cornelius.howl _at_ gmail.com >

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by c9s (Corenlius)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
