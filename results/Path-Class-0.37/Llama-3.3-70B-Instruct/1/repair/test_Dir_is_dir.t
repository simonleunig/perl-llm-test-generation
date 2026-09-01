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
if ($@) { fail('Object creation crashed: ' . $@); } 
my $result = eval { $object->is_dir() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'is_dir returns 1'); }

my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::is_dir"}) {
        $mock = mock 'Path::Class::Dir' => ( override => [ is_dir => sub { 1 } ] );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => [ is_dir => sub { 1 } ] );
    }
}
my $mock_result = eval { $mock->is_dir() };
if ($@) { fail('Mock function crashed: ' . $@); } else { is($mock_result, 1, 'Mock is_dir returns 1'); }

done_testing();