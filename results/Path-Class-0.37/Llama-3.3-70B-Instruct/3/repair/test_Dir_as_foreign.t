use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::as_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'as_foreign is defined'); }

# Test case 1: Successful conversion to a foreign format
my $dir = Path::Class::Dir->new('t');
my $result = eval { $dir->as_foreign('Unix') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Error handling for invalid foreign type
my $invalid_type_result = eval { $dir->as_foreign('InvalidType') };
if ($@) { ok($@, 'Function throws error for invalid foreign type'); } else { fail('Function did not throw error for invalid foreign type'); }

# Test case 3: Edge case for empty directory
my $empty_dir = Path::Class::Dir->new('');
my $empty_dir_result = eval { $empty_dir->as_foreign('Unix') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $empty_dir_result, 'Function returns result for empty directory'); }

done_testing();
