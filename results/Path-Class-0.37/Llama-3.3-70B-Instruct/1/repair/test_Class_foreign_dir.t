use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'foreign_dir is defined'); }

my $result = eval { Path::Class::foreign_dir('/path/to/directory') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid directory path'); }

$result = eval { Path::Class::foreign_dir('invalid/path') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for invalid directory path'); }

$result = eval { Path::Class::foreign_dir('') };
if ($@) { ok(1, 'Function crashes with empty directory path'); } else { fail('Function did not crash with empty directory path'); }

$result = eval { Path::Class::foreign_dir('/path/with/special/characters!@#$%^&*()') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for directory path with special characters'); }

$result = eval { Path::Class::foreign_dir('/path/with/non-ascii/characters/') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for directory path with non-ASCII characters'); }

done_testing();