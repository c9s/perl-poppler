use 5.010000;

use strict;
use warnings FATAL => 'all';
use ExtUtils::PkgConfig;
use ExtUtils::MakeMaker;

# check for poppler-glib library
my %extreqs = (
    poppler => '0.18',
);

my %poppler_cfg;
print "Checking poppler lib\n";
eval { %poppler_cfg = ExtUtils::PkgConfig->find ("poppler >= $extreqs{poppler}"); };
if ($@ ne '') {
    warn $@; 
    WriteMakefile(
        PREREQ_FATAL => 1,
    );
    exit 1;
}

WriteMakefile(
    NAME          => 'Poppler',
    VERSION_FROM  => 'lib/Poppler.pm',
    ABSTRACT_FROM => 'lib/Poppler.pm',
    AUTHOR        => q{Jeremy Volkening <jdv@base2bio.com>},
    CONFIGURE_REQUIRES => {
        "ExtUtils::MakeMaker" => 0,
        "ExtUtils::PkgConfig" => 0,
    },
    BUILD_REQUIRES => {
        "Test::More" => 0,
    },
    PREREQ_PM     => {
        "Glib::Object::Introspection" => "0.016",
        "Cairo"      => 0,
        "Carp"       => 0,
        "Exporter"   => 0,
        "URI"        => "1.60",
    },
    META_MERGE        => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                web => 'https://github.com/c9s/perl-poppler',
                url => 'https://github.com/c9s/perl-poppler.git',
            },
        },
    },
    test  => {TESTS => "t/*.t"},
    dist  => {COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => {FILES => 'Poppler-*' },
);
