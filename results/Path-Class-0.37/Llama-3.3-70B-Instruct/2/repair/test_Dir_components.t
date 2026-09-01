use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::components"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'components is defined'); }

my $dir = Path::Class::Dir->new('path/to/directory');
my $result = eval { $dir->components() };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result'); }

$result = eval { $dir->components(1, 2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with offset and length'); }

$result = eval { $dir->components(-1, 2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with invalid offset'); }

$result = eval { $dir->components(1, -2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with invalid length'); }

$result = eval { $dir->components('a', 2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with non-numeric offset'); }

$result = eval { $dir->components(1, 'b') };
if ($@) { fail('components crashed: ' . . $@); } else { ok(defined $result, 'components returns result with non-numeric length'); }

my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::dir_list"}) {
        $mock = mock 'Path::Class::Dir' => ( override => [ dir_list => sub { return [] } ] );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => [ dir_list => sub { return [] } ] );
    }
}

done_testing();