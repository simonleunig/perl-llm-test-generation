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
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock_dir = mock 'Path::Class::Dir' => (override => [open => sub { return undef }]);
    } else {
        $mock_dir = mock 'Path::Class::Dir' => (add => [open => sub { return undef }]);
    }
}

my $result_error = eval { $mock_dir->children() };
if ($@) { like($@, qr/Can't open directory/, 'Function throws correct error'); } else { fail('Function did not throw error'); }

END { rmdir $temp_dir; }

done_testing();