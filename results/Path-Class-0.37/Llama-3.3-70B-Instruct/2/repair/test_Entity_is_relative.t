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

my $entity = bless({}, 'Path::Class::Entity');

my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::is_absolute"}) {
        $mock = mock 'Path::Class::Entity' => ( override => [ is_absolute => sub { return 0; } ] );
    } else {
        $mock = mock 'Path::Class::Entity' => ( add => [ is_absolute => sub { return 0; } ] );
    }
}

my $result = eval { $entity->is_relative() };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Relative path returns true'); }

$mock = mock 'Path::Class::Entity' => ( override => [ is_absolute => sub { return 1; } ] );
$result = eval { $entity->is_relative() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Absolute path returns false'); }

$mock = mock 'Path::Class::Entity' => ( override => [ is_absolute => sub { die 'Mock error'; } ] );
my $error = eval { $entity->is_relative() };
if ($@) { ok(1, 'Error handling works'); like($@, qr/Mock error/, 'Error message correct'); } else { fail('Error handling failed'); }

done_testing();