package Poppler;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( );

our $VERSION = '0.03';

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
    # or if you want to open the pdf in perl, or use some othe source:
    #  open (PDF, "<FILE.PDF");
    #  read (PDF, my $data, -s "FILE.PDF");
    #  close (PDF);
    #  my $o = Poppler::Document->new_from_data($data, length($data));

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


=head1 L<Poppler::Document>

=head2 L<Poppler::Document> Blessed Object = Poppler::Document->new_from_file( STRING uri )

=head2 L<Poppler::Document> Blessed Object = Poppler::Document->new_from_data( STRING pdf_data, length ( STRING pdf_data ) )

=head2 BOOLEAN = $poppler_document->save( STRING uri )

=head2 BOOLEAN = $poppler_document->save_a_copy( STRING uri )

=head2 INT = $poppler_document->get_n_pages()

=head2 BOOLEAN = $poppler_documnet->has_attachment()

=head2 LIST OF L<Poppler::Attachment> = $poppler_document->get_attachments()

=head2 L<Poppler::Page> Blessed Object = $poppler_document->get_page_by_label( STRING label );

=head2 L<Poppler::Page> Blessed Object = $poppler_document->get_page( INT page_number );



=head1 L<Poppler::Page>

=head2 INT = $poppler_page->get_index( ) 

=head2 $poppler_page->render_to_cairo( L<Cairo::Context> cr )

=head2 L<Poppler::OutputDevData> Blessed Object = $page->prepare_output_dev( DOUBLE scale , INT rotation , BOOLEAN transparent )




=head1 L<Poppler::OutputDevData>

=head2 L<Cairo::Context> = $output_dev_data->get_cairo_context()

=head2 L<Cairo::Surface> = $output_dev_data::OutputDevData->get_cairo_surface()

=head2 SCALAR data = $output_dev_data->get_cairo_data()


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
