package Test::HTTP::Server::Simple;

our $VERSION = '0.01';

use warnings;
use strict;
use Carp;

use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/started_ok/;

use Test::Builder;
my $Tester = Test::Builder->new;

=head1 NAME

Test::HTTP::Server::Simple - Test::More functions for HTTP::Server::Simple


=head1 SYNOPSIS

    use Test::More tests => 42;
    use Test::HTTP::Server::Simple;

    my $s = My::WebServer->new;

    my $url_root = started_ok($s, "start up my web server);

    # connect to "$url_root/cool/site" and test with Test::WWW::Mechanize,
    # Test::HTML::Tidy, etc

  
=head1 DESCRIPTION

This module provides functions to test an L<HTTP::Server::Simple>-based web
server.  Currently, it provides only one such function: C<started_ok>.

=over 4 

=item started_ok $server, [$text]

C<started_ok> takes an instance of a subclass of L<HTTP::Server::Simple> and
an optional test description.  The server needs to have been configured (specifically,
its port needs to have been set), but it should not have been run or backgrounded.
C<started_ok> calls C<background> on the server, which forks it to run in the background.
L<Test::HTTP::Server::Simple> takes care of killing the server when your test script dies,
even if you kill your test script with an interrupt.  C<started_ok> returns the URL 
C<http://localhost:$port> which you can use to connect to your server.

=cut

my @CHILD_PIDS;

# If an interrupt kills perl, END blocks are not run.  This
# essentially converts interrupts (like CTRL-C) into a standard
# perl exit (even if we're inside an eval {}).
$SIG{INT} = sub { exit };

END {
    kill 9, @CHILD_PIDS if @CHILD_PIDS;
} 

sub started_ok {
    my $server = shift;
    my $text   = shift;
    $text = 'started server' unless defined $text;

    unless (UNIVERSAL::isa($server, 'HTTP::Server::Simple')) {
	$Tester->ok(0, $text);
	$Tester->diag("$server is not an HTTP::Server::Simple");
	return;
    } 

    my $port = $server->port;
    my $pid;
    
    eval { $pid = $server->background; };

    if ($@) {
	my $error_text = $@;  # In case the next line changes it.
	$Tester->ok(0, $text);
	$Tester->diag("HTTP::Server::Simple->background failed: $error_text");
	return;
    }

    unless ($pid =~ /^-?\d+$/) {
	$Tester->ok(0, $text);
	$Tester->diag("HTTP::Server::Simple->background didn't return a valid PID");
	return;
    } 

    push @CHILD_PIDS, $pid;

    $Tester->ok(1, $text);

    return "http://localhost:$port";
} 

=back

=head1 DEPENDENCIES

L<Test::Builder>, L<HTTP::Server::Simple>.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

Installs an interrupt signal handler, which may override any that another part
of your program has installed.

Please report any bugs or feature requests to
C<bug-test-http-server-simple@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Glasser  C<< <glasser@bestpractical.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005, Best Practical Solutions, LLC.  All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

1;

