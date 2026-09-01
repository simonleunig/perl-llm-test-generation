use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::hash_to_array"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'hash_to_array is defined'); }

# Test case 1: Empty hash
my $empty_hash = {};
my $result = eval { XML::Simple->hash_to_array(undef, undef, $empty_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $empty_hash, 'Empty hash returns original hash'); }

# Test case 2: Non-hash values
my $non_hash = { key => 'value' };
my $result2 = eval { XML::Simple->hash_to_array(undef, undef, $non_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, $non_hash, 'Non-hash values return original hash'); }

# Test case 3: KeyAttr option not defined
my $hashref = { key1 => { subkey => 'value' } };
my $result3 = eval { XML::Simple->hash_to_array(undef, undef, $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result3, $hashref, 'KeyAttr option not defined returns original hash'); }

# Test case 4: KeyAttr option defined
my $mock_object = mock 'XML::Simple' => (
    opt => { keyattr => { parent => ['key'] } },
    copy_hash => sub { my ($self, $hash, @args) = @_; return { %$hash, @args } },
);
my $result4 = eval { $mock_object->hash_to_array(undef, 'parent', $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { is(ref $result4, 'ARRAY', 'KeyAttr option defined returns array reference'); }

# Test case 5: Large input hash
my $large_hash = {};
for (my $i = 0; $i < 1000; $i++) {
    $large_hash->{"key$i"} = { subkey => "value$i" };
}
my $result5 = eval { XML::Simple->hash_to_array(undef, undef, $large_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is(ref $result5, 'ARRAY', 'Large input hash returns array reference'); }

done_testing();
