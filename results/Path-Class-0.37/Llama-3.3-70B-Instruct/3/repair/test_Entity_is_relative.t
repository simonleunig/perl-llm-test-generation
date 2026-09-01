use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_relative is defined'); }

my $entity = bless {}, 'Path::Class::Entity';
my $result = eval { $entity->is_relative() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::is_absolute"}) {
        $mock = mock 'Path::Class::Entity' => ( override => [ is_absolute => sub { return 1; }, ] );
    } else {
        $mock = mock 'Path::Class::Entity' => ( add => [ is_absolute => sub { return 1; }, ] );
    }
}
my $result_mock = eval { $entity->is_relative() };
if ($@) { fail('Mock function crashed: ' . $@); } else { ok(!$result_mock, 'Function returns false for absolute path'); }

$mock = mock 'Path::Class::Entity' => ( override => [ is_absolute => sub { return 0; }, ] );
my $result_mock_false = eval { $entity->is_relative() };
if ($@) { fail('Mock function crashed: ' . $@); } else { ok($result_mock_false, 'Function returns true for relative path'); }

done_testing();