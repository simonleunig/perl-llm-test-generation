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
my $dir = Path::Class::Dir->new('t');
my $result = eval { $dir->relative() };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result, 'relative returns result'); }

# Test case 2: relative with current directory as argument
my $current_dir = Path::Class::Dir->new('.');
$result = eval { $dir->relative($current_dir) };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result, 'relative returns result with current directory'); }

# Test case 3: relative with different directory as argument
my $different_dir = Path::Class::Dir->new('different');
$result = eval { $dir->relative($different_dir) };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result, 'relative returns result with different directory'); }

# Test case 4: relative with string argument
my $string_arg = 'string_arg';
$result = eval { $dir->relative($string_arg) };
if ($@) { fail('relative crashed: ' . $@); } else { ok(defined $result, 'relative returns result with string argument'); }

done_testing();
