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
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Poppler.pm', # retrieve abstract from module
       AUTHOR         => 'Cornelius <cornelius.howl@gmail.com>') : ()),
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
    INC     => `pkg-config --cflags poppler-glib`,
    LIBS    => `pkg-config --libs poppler-glib`,
);
