use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'foreign_file is defined'); }

my $result = eval { Path::Class::foreign_file('/path/to/file') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid foreign path'); }

$result = eval { Path::Class::foreign_file('invalid/path') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for invalid foreign path'); }

$result = eval { Path::Class::foreign_file('') };
if ($@) { ok($@, 'Function dies with empty foreign path'); like($@, qr/Invalid system type/, 'Error message correct'); } else { fail('Function did not die with empty foreign path'); }

$result = eval { Path::Class::foreign_file(undef) };
if ($@) { ok($@, 'Function dies with undefined foreign path'); like($@, qr/Invalid system type/, 'Error message correct'); } else { fail('Function did not die with undefined foreign path'); }

done_testing();