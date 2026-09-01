use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

# Test case 1: relative with no arguments
my $dir = Path::Class::Dir->new('/path/to/dir');
my $result = eval { $dir->relative() };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result, 'relative returns result'); }

# Test case 2: relative with current directory as argument
my $current_dir = Path::Class::Dir->new('.');
my $result2 = eval { $dir->relative($current_dir) };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result2, 'relative returns result with current directory'); }

# Test case 3: relative with same directory as argument
my $same_dir = Path::Class::Dir->new('/path/to/dir');
my $result3 = eval { $dir->relative($same_dir) };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result3, 'relative returns result with same directory'); }

# Test case 4: relative with different directory as argument
my $different_dir = Path::Class::Dir->new('/path/to/other/dir');
my $result4 = eval { $dir->relative($different_dir) };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result4, 'relative returns result with different directory'); }

done_testing();
