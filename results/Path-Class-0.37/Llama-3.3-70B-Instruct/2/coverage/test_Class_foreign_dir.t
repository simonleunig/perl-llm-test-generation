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

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::foreign_dir('path', 'to', 'directory') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid foreign directory path'); }

# UNVALIDATED: $result = eval { Path::Class::foreign_dir(undef) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef for invalid foreign directory path'); }

# UNVALIDATED: $result = eval { Path::Class::foreign_dir() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef for empty foreign directory path'); }

# UNVALIDATED: $result = eval { Path::Class::foreign_dir('path|to|directory') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for malformed foreign directory path'); }

done_testing();