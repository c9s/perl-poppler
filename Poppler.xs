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




MODULE = Poppler		PACKAGE = Poppler::Document		PREFIX = poppler_document_

PopplerDocument*
poppler_document_new_from_file( class , filename);
    char* filename
PREINIT:
    PopplerDocument *document;
CODE:
    document = poppler_document_new_from_file( filename , NULL , NULL );
    SV *doc_sv = poppler_document_to_sv( document );
    RETVAL = doc_sv;
OUTPUT:
    RETVAL


PopplerPage*
poppler_document_get_page ( class ,document , page );
    PopplerDocument* document;
    int page;
PREINIT:
    PopplerPage* ppage;
CODE:
    ppage = poppler_document_get_page( document , page );
    SV *page_sv = poppler_page_to_sv( ppage );
    RETVAL = page_sv;
OUTPUT:
    RETVAL

MODULE = Poppler    PACKAGE =  Poppler::Page     PREFIX = poppler_page

