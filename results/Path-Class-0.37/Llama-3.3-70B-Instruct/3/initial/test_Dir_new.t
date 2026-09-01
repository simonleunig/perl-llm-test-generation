use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case 1: Empty input
my $result = eval { Path::Class::Dir->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with empty input'); }

# Test case 2: Single directory path component
$result = eval { Path::Class::Dir->new('path') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with single directory path component'); }

# Test case 3: Multiple directory path components
$result = eval { Path::Class::Dir->new('path', 'to', 'directory') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with multiple directory path components'); }

# Test case 4: Path::Class::Dir object as input
my $dir = Path::Class::Dir->new('path');
$result = eval { Path::Class::Dir->new($dir) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with Path::Class::Dir object as input'); }

# Test case 5: Undef as input
$result = eval { Path::Class::Dir->new(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef with undef as input'); }

# Test case 6: Empty string as input
$result = eval { Path::Class::Dir->new('') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with empty string as input'); }

done_testing();
