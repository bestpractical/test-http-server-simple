use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::HTTP::Server::Simple',
    license             => 'perl',
    dist_author         => 'David Glasser <glasser@bestpractical.com>',
    dist_version_from   => 'lib/Test/HTTP/Server/Simple.pm',
    requires => {
        'Test::More' => 0,
        'Test::Builder' => 0,
        'HTTP::Server::Simple' => 0,
    },
    add_to_cleanup      => [ 'Test-HTTP-Server-Simple-*' ],
);

$builder->create_build_script();
