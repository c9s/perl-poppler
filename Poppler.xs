#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include "perl-poppler.h"
#include <poppler.h>
#include <poppler/glib/poppler.h>
#include <poppler/glib/poppler-page.h>

MODULE = Poppler		PACKAGE = Poppler::Document		PREFIX = poppler_document_

PopplerDocument*
poppler_document_new_from_file (filename);
    char* filename
CODE:
    RETVAL = poppler_document_new_from_file( filename , NULL , NULL );
OUTPUT:
    RETVAL


PopplerPage*
poppler_document_get_page ( document , page );
    PopplerDocument* document;
    int page;
CODE:
    RETVAL = poppler_document_get_page( document , page );
OUTPUT:
    RETVAL

