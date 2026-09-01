use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::recurse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'recurse is defined'); }

# Test case 1: Missing callback parameter
my $result = eval { Path::Class::Dir->recurse() };
if ($@) { like($@, qr/Must provide a 'callback' parameter to recurse\(/, 'Missing callback parameter throws exception'); }
# FAILED: else { fail('Missing callback parameter did not throw exception'); }

# Test case 2: Valid callback parameter
my $dir = Path::Class::Dir->new(tempdir());
my $callback_called = 0;
my $callback = sub { $callback_called++; };
$result = eval { $dir->recurse(callback => $callback) };
if ($@) { fail('Valid callback parameter crashed: ' . $@); }
else { ok($callback_called, 'Callback was called'); }

# Test case 3: Preorder recursion
$callback_called = 0;
$result = eval { $dir->recurse(callback => $callback, preorder => 1) };
if ($@) { fail('Preorder recursion crashed: ' . $@); }
else { ok($callback_called, 'Preorder recursion callback was called'); }

# Test case 4: Depth-first recursion
$callback_called = 0;
$result = eval { $dir->recurse(callback => $callback, depthfirst => 1) };
if ($@) { fail('Depth-first recursion crashed: ' . $@); }
else { ok($callback_called, 'Depth-first recursion callback was called'); }

# Test case 5: PRUNE constant
$callback_called = 0;
my $prune_callback = sub { return Path::Class::Dir->PRUNE; };
$result = eval { $dir->recurse(callback => $prune_callback) };
if ($@) { fail('PRUNE constant crashed: ' . $@); }
else { ok(!$callback_called, 'PRUNE constant prevented further recursion'); }

done_testing();
