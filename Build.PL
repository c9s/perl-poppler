use 5.010000;

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Poppler',
    license            => 'perl',
    dist_author        => q{Jeremy Volkening <jdv@base2bio.com>},
    configure_requires => {
        'Module::Build'       => 0,
        'ExtUtils::PkgConfig' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Glib::Object::Introspection' => "0.016",
        'Carp'     => 0,
        'Exporter' => 0,
        'URI'      => "1.60",
        'Cairo'    => 0,
    },
    meta_merge => {
        resources => {
            repository => 'https://github.com/c92/perl-poppler'
        }
    },
    add_to_cleanup => [ 'Poppler-*' ],
    create_license => 1,
    share_dir => 'share',
);
$builder->create_build_script;
