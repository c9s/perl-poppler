#ifndef PERL_POPPLER_H
#define PERL_POPPLER_H

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

#endif
