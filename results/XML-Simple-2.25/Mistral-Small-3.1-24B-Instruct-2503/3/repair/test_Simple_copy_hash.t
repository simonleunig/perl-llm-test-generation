use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::copy_hash"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'copy_hash is defined'); }

{
    my $orig = { key1 => 'value1', key2 => 'value2' };
    my @extra = (key3 => 'value3', key4 => 'value4');
    my $result = eval { XML::Simple::copy_hash(undef, $orig, @extra) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key1}, 'value1', 'Original key1 value is preserved');
        is($result->{key2}, 'value2', 'Original key2 value is preserved');
        is($result->{key3}, 'value3', 'Extra key3 value is added');
        is($result->{key4}, 'value4', 'Extra key4 value is added');
    }
}

{
    my $orig = {};
    my @extra = (key1 => 'value1');
    my $result = eval { XML::Simple::copy_hash(undef, $orig, @extra) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key1}, 'value1', 'Extra key1 value is added to empty hash');
    }
}

{
    my $orig = 'not a hash reference';
    my @extra = (key1 => 'value1');
    my $result = eval { XML::Simple::copy_hash(undef, $orig, @extra) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result, { key1 => 'value1' }, 'Returns a new hash with extra key-value pairs');
    }
}

{
    my $orig = { key1 => 'value1' };
    my @extra = (key1 => 'new_value1', key2 => 'value2');
    my $result = eval { XML::Simple::copy_hash(undef, $orig, @extra) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key1}, 'new_value1', 'Duplicate key in @extra overwrites original value');
        is($result->{key2}, 'value2', 'Extra key2 value is added');
    }
}

{
    my $orig = { key1 => 'value1' };
    my @extra = ();
    my $result = eval { XML::Simple::copy_hash(undef, $orig, @extra) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result, { key1 => 'value1' }, 'Returns a copy of the original hash');
    }
}

{
    my $orig = undef;
    my @extra = (key1 => 'value1');
    my $result = eval { XML::Simple::copy_hash(undef, $orig, @extra) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result, { key1 => 'value1' }, 'Returns a new hash with extra key-value pairs');
    }
}

done_testing();