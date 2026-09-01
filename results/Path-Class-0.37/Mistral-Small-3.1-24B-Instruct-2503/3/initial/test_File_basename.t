use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::basename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'basename is defined'); }

# Test case: Normal operation with a valid file attribute
{
    my $file = bless { file => 'example.txt' }, 'Path::Class::File';
    my $result = eval { Path::Class::File::basename($file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'example.txt', 'basename returns correct filename');
    }
}

# Test case: Edge case with undefined file attribute
{
    my $file = bless { file => undef }, 'Path::Class::File';
    my $result = eval { Path::Class::File::basename($file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'basename returns undef when file attribute is undefined');
    }
}

# Test case: Edge case with empty file attribute
{
    my $file = bless { file => '' }, 'Path::Class::File';
    my $result = eval { Path::Class::File::basename($file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'basename returns empty string when file attribute is empty');
    }
}

# Test case: Edge case with file attribute set to zero
{
    my $file = bless { file => 0 }, 'Path::Class::File';
    my $result = eval { Path::Class::File::basename($file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'basename returns 0 when file attribute is set to zero');
    }
}

# Test case: Edge case with file attribute set to a non-string value
{
    my $file = bless { file => [] }, 'Path::Class::File';
    my $result = eval { Path::Class::File::basename($file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'ARRAY(0x' . sprintf('%x', scalar(bless [], 'ARRAY')) . ')', 'basename returns stringified array reference');
    }
}

done_testing();
