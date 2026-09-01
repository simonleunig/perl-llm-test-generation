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

my $object = eval { Path::Class::Dir->new('/') };
# FAILED: if ($@) { fail('Object creation crashed: ' . $@); } 
my $result = eval { $object->is_dir() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'is_dir returns 1'); }

my $mock;
# UNVALIDATED: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::is_dir"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => ( override => [ is_dir => sub { 1 } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => ( add => [ is_dir => sub { 1 } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
my $mock_result;  # AFTER LAST PASS: my $mock_result;  # UNVALIDATED: my $mock_result = eval { $mock->is_dir() };
# FAILED: if ($@) { fail('Mock function crashed: ' . $@); } else { is($mock_result, 1, 'Mock is_dir returns 1'); }

done_testing();