use 5.010000;

use ExtUtils::PkgConfig;
use ExtUtils::MakeMaker;

my %extreqs = (
    poppler => '0.10.5',
    # XXX: poppler-data , glib ?
);

my %poppler_cfg;
print "Checking poppler lib\n";
eval { %poppler_cfg = ExtUtils::PkgConfig->find ("poppler >= $extreqs{poppler}"); };
if ($@ ne '') {
    warn $@; 
    exit 0;
}

WriteMakefile(
    NAME              => 'Poppler',
    VERSION_FROM      => 'lib/Poppler.pm', # finds $VERSION
    PREREQ_PM         => {
        Cairo => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Poppler.pm', # retrieve abstract from module
       AUTHOR         => 'Cornelius <cornelius.howl@gmail.com>') : ()),
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC     => `pkg-config --cflags poppler-glib`,
    LIBS    =>  `pkg-config --libs poppler-glib`,
    XS      => {
        'Poppler.xs' => 'Poppler.c',
    },
    'OBJECT' => 'Poppler$(OBJ_EXT)' ,
);
