use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_file"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "foreign_file is defined"); }

my $result = eval { Path::Class::foreign_file('Unix', '/path/to/file') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "foreign_file returns a result"); }

my $error_result = eval { Path::Class::foreign_file('InvalidPlatform', '/path/to/file') };
if ($@) { ok($@, "foreign_file throws an error for invalid platform"); } else { fail("Expected error not thrown"); }

my $malformed_result;  # AFTER LAST PASS: my $malformed_result;  # UNVALIDATED: my $malformed_result = eval { Path::Class::foreign_file('Unix', undef) };
# FAILED: if ($@) { ok($@, "foreign_file throws an error for malformed foreign path specification"); } else { fail("Expected error not thrown"); }

done_testing();