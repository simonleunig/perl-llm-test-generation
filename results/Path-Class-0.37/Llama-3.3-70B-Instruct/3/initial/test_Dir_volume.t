use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

# Test cases with eval protection
my $dir = Path::Class::Dir->new('path');
my $result = eval { $dir->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test with volume
my $dir_with_volume = Path::Class::Dir->new('C:\\path');
$dir_with_volume->{volume} = 'C:';
my $result_with_volume = eval { $dir_with_volume->volume() };
if ($@) { fail('Function crashed with volume: ' . $@); } else { is($result_with_volume, 'C:', 'Function returns volume'); }

# Test without volume
my $dir_without_volume = Path::Class::Dir->new('/path');
my $result_without_volume = eval { $dir_without_volume->volume() };
if ($@) { fail('Function crashed without volume: ' . $@); } else { is($result_without_volume, '', 'Function returns empty string without volume'); }

done_testing();
