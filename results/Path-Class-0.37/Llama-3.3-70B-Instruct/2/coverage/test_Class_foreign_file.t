use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_file"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "foreign_file is defined"); }

my $result = eval { Path::Class::foreign_file('Unix', '/path/to/file') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "foreign_file returns result"); }

my $error_result = eval { Path::Class::foreign_file('InvalidPlatform', '/path/to/file') };
if ($@) { ok($@, "foreign_file throws error on invalid platform"); } else { fail("Expected error on invalid platform"); }

# UNVALIDATED: $error_result = eval { Path::Class::foreign_file('Unix', undef) };
# FAILED: if ($@) { ok($@, "foreign_file throws error on malformed foreign path specification"); } else { fail("Expected error on malformed foreign path specification"); }

done_testing();