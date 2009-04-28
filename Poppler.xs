#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include "perl-poppler.h"


#include <poppler.h>
#include <poppler/glib/poppler.h>
#include <poppler/glib/poppler-page.h>


#define FAIL(msg)							\
    do { fprintf (stderr, "FAIL: %s\n", msg); exit (-1); } while (0)


typedef struct {
    PopplerDocument *handle;
} hPopplerDocument;

typedef struct {
    PopplerPage *handle;
} hPopplerPage;

typedef struct {
    PopplerAttachment *handle;
} hPopplerAttachment;

typedef struct {
  unsigned char *cairo_data;
  cairo_surface_t *surface;
  cairo_t *cairo;
} OutputDevData;


typedef struct {
    double w;
    double h;
} hPageDimension;

MODULE = Poppler		PACKAGE = Poppler::Document

BOOT:
    g_type_init();

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
    RETVAL = ( ret == TRUE ) ? 1 : 0;   // XXX: should convert in typemap
OUTPUT:
    RETVAL

int
hPopplerDocument::get_n_pages()
CODE:
    RETVAL = poppler_document_get_n_pages( THIS->handle );
OUTPUT:
    RETVAL


int
hPopplerDocument::has_attachments()
PREINIT:
    gboolean ret;
CODE:
    ret = poppler_document_has_attachments( THIS->handle );
    RETVAL = ( ret == TRUE ) ? 1 : 0;
OUTPUT:
    RETVAL


void
hPopplerDocument::get_attachments()
PREINIT:
    GList* i;
    GList* list;
PPCODE:
    list = (GList*) poppler_document_get_attachments( THIS->handle );
    for (i = list; i != NULL; i = i->next) {
        SV * sv;
        hPopplerDocument * pv;
        Newz(0, pv, 1, hPopplerDocument );
        sv_setref_pv( sv , "Poppler::Attachment" , (void*) pv );
        XPUSHs ( sv_2mortal( sv ) );
    }
    g_list_free(list);



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


##ifdef POPPLER_WITH_GDK
#void                   poppler_page_render_to_pixbuf     (PopplerPage        *page,
#							  int                 src_x,
#							  int                 src_y,
#							  int                 src_width,
#							  int                 src_height,
#							  double              scale,
#							  int                 rotation,
#							  GdkPixbuf          *pixbuf);
#void          poppler_page_render_to_pixbuf_for_printing (PopplerPage        *page,
#							  int                 src_x,
#							  int                 src_y,
#							  int                 src_width,
#							  int                 src_height,
#							  double              scale,
#							  int                 rotation,
#							  GdkPixbuf          *pixbuf);
#GdkPixbuf             *poppler_page_get_thumbnail_pixbuf (PopplerPage        *page);
#void                poppler_page_render_selection_to_pixbuf (
#							  PopplerPage        *page,
#							  gdouble             scale,
#							  int		      rotation,
#							  GdkPixbuf          *pixbuf,
#							  PopplerRectangle   *selection,
#							  PopplerRectangle   *old_selection,
#							  PopplerSelectionStyle style,
#							  GdkColor           *glyph_color,
#							  GdkColor           *background_color);
##endif /* POPPLER_WITH_GDK */

# #ifdef POPPLER_HAS_CAIRO
# void                   poppler_page_render               (PopplerPage        *page,
# 							  cairo_t            *cairo);
# void                   poppler_page_render_for_printing  (PopplerPage        *page,
# 							  cairo_t            *cairo);
# cairo_surface_t       *poppler_page_get_thumbnail        (PopplerPage        *page);
# void                   poppler_page_render_selection     (PopplerPage        *page,
# 							  cairo_t            *cairo,
# 							  PopplerRectangle   *selection,
# 							  PopplerRectangle   *old_selection,
# 							  PopplerSelectionStyle style,
# 							  PopplerColor       *glyph_color,
# 							  PopplerColor       *background_color);
# #endif /* POPPLER_HAS_CAIRO */


int
hPopplerPage::get_index()
CODE:
    RETVAL = poppler_page_get_index( THIS->handle );
OUTPUT:
    RETVAL


double
hPopplerPage::get_duration()
CODE:
    RETVAL = poppler_page_get_duration( THIS->handle );
OUTPUT:
    RETVAL

int
hPopplerPage::find_text( text );
    char *text;
PREINIT:
    GList *list;
CODE:
    list = poppler_page_find_text( THIS->handle, text );
    // XXX: convert glist for perl
    RETVAL = 1;
OUTPUT:
    RETVAL

## XXX: static function
## OutputDevData*
## hPopplerPage::prepare_output_dev(  scale , rotation , _transparent ) ;
##     double scale;
##     int rotation;
##     int _transparent;
## PREINIT:
##     OutputDevData *output_dev_data;
##     gboolean transparent;
## CODE:
##     transparent = ( _transparent == 1 ? TRUE : FALSE );
##     char* class = "Poppler::OutputDevData";
##     poppler_page_prepare_output_dev(
##         THIS->handle,
##         rotation,
##         transparent,
##         output_dev_data
##     );
##     RETVAL = output_dev_data;
## OUTPUT:
##     RETVAL


## void
## hPopplerPage::copy_to_pixbuf( output_dev_data )
##     OutputDevData *output_dev_data;
## PREINIT:
##     GdkPixbuf * pixbuf;
## CODE:
##     poppler_page_copy_to_pixbuf( THIS->handle , pixbuf , output_dev_data );
## NO_OUPUT:


MODULE = Poppler    PACKAGE = Poppler::Attachment

int
hPopplerAttachment::save( filename );
    char * filename;
PREINIT:
    GError **error;
    gboolean ret;
CODE:
    ret = poppler_attachment_save( THIS->handle , filename , error );
    RETVAL = ( ret == TRUE ) ? 1 : 0;
OUTPUT:
    RETVAL


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



MODULE = Poppler    PACKAGE = Poppler::OutputDevData

cairo_t*
OutputDevData::get_cairo_context()
CODE:
    char * class = "Cairo::Context";
    RETVAL = THIS->cairo;
OUTPUT:
    RETVAL

cairo_surface_t*
OutputDevData::get_cairo_surface()
CODE:
    char * class = "Cairo::Surface";
    RETVAL = THIS->surface;
OUTPUT:
    RETVAL

SV*
OutputDevData::get_cairo_data()
CODE:
    RETVAL = (SV*) THIS->cairo_data;
OUTPUT:
    RETVAL





