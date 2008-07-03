use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::HTTP::Server::Simple',
    AUTHOR              => 'David Glasser <glasser@bestpractical.com>',
    VERSION_FROM        => 'lib/Test/HTTP/Server/Simple.pm',
    ABSTRACT_FROM       => 'lib/Test/HTTP/Server/Simple.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Storable' => 0,
        'Test::More' => 0,
        'Test::Builder' => 0,
        'Test::Builder::Tester' => 1.04,
	'HTTP::Server::Simple' => 0,
	'NEXT' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-HTTP-Server-Simple-*' },
);
