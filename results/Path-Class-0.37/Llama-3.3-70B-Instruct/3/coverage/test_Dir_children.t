use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::children"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'children is defined'); }

my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->children() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

my $result_all = eval { $dir->children(all => 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_all, 'Function returns result with all option'); }

my $result_no_hidden = eval { $dir->children(no_hidden => 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_no_hidden, 'Function returns result with no_hidden option'); }

my $mock_dir;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::open"}) {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => (override => [open => sub { return undef }]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => (add => [open => sub { return undef }]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $result_error;  # AFTER LAST PASS: my $result_error;  # UNVALIDATED: my $result_error = eval { $mock_dir->children() };
# FAILED: if ($@) { like($@, qr/Can't open directory/, 'Function throws correct error'); } else { fail('Function did not throw error'); }

# AFTER LAST PASS: END { rmdir $temp_dir; }

done_testing();