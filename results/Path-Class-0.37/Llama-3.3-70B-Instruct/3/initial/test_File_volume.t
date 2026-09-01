use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

# Test case: volume returns empty string when $self->{dir} is undefined
my $file = bless { dir => undef }, 'Path::Class::File';
my $result = eval { $file->volume };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'volume returns empty string when dir is undefined'); }

# Test case: volume returns volume of $self->{dir} when defined
my $dir = bless { volume => 'C:' }, 'Path::Class::Dir';
$file = bless { dir => $dir }, 'Path::Class::File';
$result = eval { $file->volume };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'C:', 'volume returns volume of dir when defined'); }

# Test case: volume handles edge case where $self->{dir} is not a Path::Class::Dir object
$file = bless { dir => 'not a dir object' }, 'Path::Class::File';
$result = eval { $file->volume };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'volume handles edge case where dir is not a Path::Class::Dir object'); }

done_testing();
