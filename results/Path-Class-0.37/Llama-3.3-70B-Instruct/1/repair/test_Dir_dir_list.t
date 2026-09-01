use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::dir_list"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir_list is defined'); }

my $dir = Path::Class::Dir->new('path', 'to', 'directory');

my $result = eval { $dir->dir_list() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
if (ref $result eq 'ARRAY') {
    is(ref $result, 'ARRAY', 'Returns an array reference');
} else {
    fail('Returns an array reference');
}

$result = eval { $dir->dir_list(1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
if (ref $result eq 'ARRAY') {
    is(ref $result, 'ARRAY', 'Returns an array reference');
} else {
    fail('Returns an array reference');
}

$result = eval { $dir->dir_list(1, 2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
if (ref $result eq 'ARRAY') {
    is(ref $result, 'ARRAY', 'Returns an array reference');
} else {
    fail('Returns an array reference');
}

$result = eval { $dir->dir_list(-1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
if (ref $result eq 'ARRAY') {
    is(ref $result, 'ARRAY', 'Returns an array reference');
} else {
    fail('Returns an array reference');
}

$result = eval { $dir->dir_list(1, -2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
if (ref $result eq 'ARRAY') {
    is(ref $result, 'ARRAY', 'Returns an array reference');
} else {
    fail('Returns an array reference');
}

my $scalar_result = eval { scalar $dir->dir_list(1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $scalar_result, 'Function returns result in scalar context'); }
is(ref $scalar_result, '', 'Returns a scalar value');

done_testing();