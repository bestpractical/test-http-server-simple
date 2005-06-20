#!/usr/bin/perl

use Test::More tests => 11;
use Test::Builder::Tester;

BEGIN { use_ok "Test::HTTP::Server::Simple" }

BEGIN { use_ok "HTTP::Server::Simple" }

ok(defined(&started_ok), "function 'started_ok' exported");

test_out("not ok 1 - bar");
test_fail(+2);
test_diag("foo is not an HTTP::Server::Simple");
started_ok("foo", "bar");
test_test("first arg to started_ok must be an HTTP::Server::Simple");

test_out("not ok 1 - baz");
test_fail(+2);
test_diag("HTTP::Server::Simple->background failed: random failure");
started_ok(THSS::FailOnBackground->new(1234), "baz");
test_test("detect background failure");

test_out("not ok 1 - blop");
test_fail(+2);
test_diag("HTTP::Server::Simple->background didn't return a valid PID");
started_ok(THSS::ReturnInvalidPid->new(4194), "blop");
test_test("detect bad pid");

BEGIN { use_ok "HTTP::Server::Simple::CGI" }

test_out("ok 1 - beep");
my $URL = started_ok(HTTP::Server::Simple::CGI->new(9583), "beep");
test_test("start up correctly");

is($URL, "http://localhost:9583");

test_out("ok 1 - started server");
$URL = started_ok(HTTP::Server::Simple::CGI->new(9384));
test_test("start up correctly (with default message)");

is($URL, "http://localhost:9384");


# unfortunately we do not test the child-killing properties of THHS,
# even though that's the main point of the module


package THSS::FailOnBackground;
use base qw/HTTP::Server::Simple/;
sub background { die "random failure\n" }

package THSS::ReturnInvalidPid;
use base qw/HTTP::Server::Simple/;
sub background { return "" }

