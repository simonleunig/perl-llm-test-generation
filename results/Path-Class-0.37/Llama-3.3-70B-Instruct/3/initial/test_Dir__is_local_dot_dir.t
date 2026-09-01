use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::_is_local_dot_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_is_local_dot_dir is defined'); }

# Test cases with eval protection
my $dir = Path::Class::Dir->new('.');
my $result = eval { $dir->_is_local_dot_dir('.') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Returns true for current directory'); }

$result = eval { $dir->_is_local_dot_dir('..') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Returns true for parent directory'); }

$result = eval { $dir->_is_local_dot_dir('test') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Returns false for other directories'); }

$result = eval { $dir->_is_local_dot_dir('') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Returns false for empty string'); }

$result = eval { $dir->_is_local_dot_dir(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Returns false for undef'); }

done_testing();
