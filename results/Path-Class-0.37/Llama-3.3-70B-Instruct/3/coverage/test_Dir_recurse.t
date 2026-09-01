use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::recurse"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'recurse is defined'); }

my $dir = Path::Class::Dir->new(tempdir());
my $callback_called = 0;
my $callback = sub { $callback_called++; };
my $result = eval { $dir->recurse(callback => $callback); };
if ($@) { fail("Function crashed: $@"); } else { ok($callback_called, 'Callback was called'); }

$callback_called = 0;
$result = eval { $dir->recurse(callback => $callback, preorder => 1, depthfirst => 1); };
if ($@) { fail("Function crashed: $@"); } else { ok($callback_called, 'Callback was called with preorder and depthfirst parameters'); }

$callback_called = 0;
my $prune_callback = sub { return Path::Class::Dir->PRUNE; };
$result = eval { $dir->recurse(callback => $prune_callback); };
if ($@) { fail("Function crashed: $@"); } else { ok(!$callback_called, 'Callback was not called with PRUNE constant'); }

my $error = eval { Path::Class::Dir->new('/tmp')->recurse(); };
ok($@, "Dies without callback");
like($@, qr/Must provide a 'callback' parameter to recurse/, "Error message correct");

done_testing();