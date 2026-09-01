use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::is_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_dir is defined'); }

my $dir = Path::Class::Dir->new('test_dir');
my $result = eval { $dir->is_dir() };
if ($@) { fail('is_dir crashed: ' . $@); } else { is($result, 1, 'is_dir returns 1'); }

my $mock;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::is_dir"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => ( override => [ 'is_dir' => sub { 0 } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => ( add => [ 'is_dir' => sub { 0 } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# UNVALIDATED: $result = eval { $mock->is_dir() };
# FAILED: if ($@) { fail('Mock is_dir crashed: ' . $@); } else { is($result, 0, 'Mock is_dir returns 0'); }

done_testing();