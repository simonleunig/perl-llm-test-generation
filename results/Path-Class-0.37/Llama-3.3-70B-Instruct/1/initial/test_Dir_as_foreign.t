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

# Test case 1: Successful conversion to foreign format
my $dir = Path::Class::Dir->new('path/to/directory');
my $result = eval { $dir->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(defined $result, 'as_foreign returns result'); }

# Test case 2: Invalid target operating system type
my $invalid_result = eval { $dir->as_foreign('InvalidType') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(!defined $invalid_result, 'as_foreign returns undef for invalid type'); }

# Test case 3: Edge case - empty directory path
my $empty_dir = Path::Class::Dir->new('');
my $empty_result = eval { $empty_dir->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(defined $empty_result, 'as_foreign returns result for empty directory path'); }

# Test case 4: Error handling - invalid directory object
my $invalid_dir = bless {}, 'InvalidDir';
my $invalid_dir_result = eval { $invalid_dir->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(!defined $invalid_dir_result, 'as_foreign returns undef for invalid directory object'); }

done_testing();
