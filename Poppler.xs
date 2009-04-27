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
} _PopplerDocument;

typedef struct {
    PopplerPage *handle;
} _PopplerPage;

typedef struct {
    double w;
    double h;
} _PageDimension;

MODULE = Poppler		PACKAGE = Poppler::Document

PROTOTYPES: ENABLE

_PopplerDocument*
new_from_file( class , filename )
    char * class;
    char * filename;
PREINIT:
    PopplerDocument *document;
CODE:
    g_type_init();
    Newz(0, RETVAL, 1, _PopplerDocument );
    document = poppler_document_new_from_file( filename , NULL , NULL );
    if( document == NULL ) {
        fprintf( stderr , filename );
        FAIL("poppler_document_new_from_file fail");  // XXX: show path usage
    }
    RETVAL->handle = document;
OUTPUT:
    RETVAL

_PopplerPage*
_PopplerDocument::get_page( page_num );
    int page_num;
PREINIT: 
    PopplerPage* page;
CODE:
    Newz(0, RETVAL, 1, _PopplerPage );
    page = poppler_document_get_page( THIS->handle , page_num );
    char* class = "Poppler::Page";  // XXX: bad hack
    RETVAL->handle = page;
OUTPUT:
    RETVAL



MODULE = Poppler    PACKAGE = Poppler::Page

_PageDimension*
_PopplerPage::get_size();
PREINIT:
    double doc_w;
    double doc_h;
CODE:
    poppler_page_get_size( THIS->handle , &doc_w , &doc_h );
    Newz(0, RETVAL, 1, _PageDimension );
    char * class = "Poppler::Page::Dimension";
    RETVAL->w = doc_w;
    RETVAL->h = doc_h;
OUTPUT:
    RETVAL


void
poppler_page_render (page, cr); 
    PopplerPage *page; 
    cairo_t *cr;
CODE:
OUTPUT:

    

    


