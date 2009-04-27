#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include "perl-poppler.h"
#include <poppler.h>
#include <poppler/glib/poppler.h>
#include <poppler/glib/poppler-page.h>


SV *
poppler_document_to_sv( PopplerDocument* document )
{
    SV *sv = newSV (0);
    char* pkg = "Poppler::Document";
    sv_setref_pv(sv, pkg , document );
    return sv;
}

SV *
poppler_page_to_sv( PopplerPage* page )
{
    SV *sv = newSV (0);
    char* pkg = "Poppler::Page";
    sv_setref_pv(sv, pkg , page );
    return sv;
}

#define FAIL(msg)							\
    do { fprintf (stderr, "FAIL: %s\n", msg); exit (-1); } while (0)


typedef struct {
    PopplerDocument *handle;
} hPopplerDocument;

typedef struct {
    PopplerPage *handle;
} hPopplerPage;

typedef struct {
    double w;
    double h;
} hPageDimension;

MODULE = Poppler		PACKAGE = Poppler::Document

PROTOTYPES: ENABLE

hPopplerDocument*
new_from_file( class , filename )
    char * class;
    char * filename;
PREINIT:
    PopplerDocument *document;
CODE:
    g_type_init();
    Newz(0, RETVAL, 1, hPopplerDocument );
    document = poppler_document_new_from_file( filename , NULL , NULL );
    if( document == NULL ) {
        fprintf( stderr , filename );
        FAIL("poppler_document_new_from_file fail");  // XXX: show path usage
    }
    RETVAL->handle = document;
OUTPUT:
    RETVAL

int
hPopplerDocument::save( uri )
    char * uri;
PREINIT:
    gboolean ret;
    GError **error;
CODE:
    ret = poppler_document_save( THIS->handle , uri , error );
    RETVAL = ( ret == TRUE ) ? 1 : 0;
OUTPUT:
    RETVAL


int
hPopplerDocument::save_a_copy( uri )
    char * uri;
PREINIT:
    GError **error;
    gboolean ret;
CODE:
    ret = poppler_document_save_a_copy( THIS->handle , uri , error );
    RETVAL = ( ret == TRUE ) ? 1 : 0;
OUTPUT:
    RETVAL

int
hPopplerDocument::get_n_pages()
CODE:
    RETVAL = poppler_document_get_n_pages( THIS->handle );
OUTPUT:
    RETVAL



hPopplerPage*
hPopplerDocument::get_page_by_label( label );
    char * label;
PREINIT: 
    PopplerPage* page;
CODE:
    Newz(0, RETVAL, 1, hPopplerPage );
    page = poppler_document_get_page_by_label( THIS->handle , label );
    char* class = "Poppler::Page";  
    if( page == NULL )
        FAIL( "get page failed." );
    RETVAL->handle = page;
OUTPUT:
    RETVAL




hPopplerPage*
hPopplerDocument::get_page( page_num );
    int page_num;
PREINIT: 
    PopplerPage* page;
CODE:
    Newz(0, RETVAL, 1, hPopplerPage );
    page = poppler_document_get_page( THIS->handle , page_num );
    char* class = "Poppler::Page";  // XXX: bad hack
    if( page == NULL )
        FAIL( "get page failed." );

    RETVAL->handle = page;
OUTPUT:
    RETVAL








MODULE = Poppler    PACKAGE = Poppler::Page

hPageDimension*
hPopplerPage::get_size();
PREINIT:
    double doc_w;
    double doc_h;
CODE:
    poppler_page_get_size( THIS->handle , &doc_w , &doc_h );
    Newz(0, RETVAL, 1, hPageDimension );
    char * class = "Poppler::Page::Dimension";
    RETVAL->w = doc_w;
    RETVAL->h = doc_h;
OUTPUT:
    RETVAL

void
hPopplerPage::render_to_cairo ( cr); 
    cairo_t *cr;
CODE:
    poppler_page_render( THIS->handle , cr );
OUTPUT:



MODULE = Poppler    PACKAGE = Poppler::Page::Dimension

int
hPageDimension::get_width()
CODE:
    RETVAL = THIS->w;
OUTPUT:
    RETVAL

int
hPageDimension::get_height()
CODE:
    RETVAL = THIS->h;
OUTPUT:
    RETVAL

    


