use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::hash_to_array"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'hash_to_array is defined'); }

my $empty_hash = {};
my $result = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $empty_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $empty_hash, 'Empty hash returns original hash'); }

my $non_hash = { key => 'value' };
my $result2 = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $non_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, $non_hash, 'Non-hash values return original hash'); }

my $hashref = { key1 => { subkey => 'value' } };
my $result3 = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result3, $hashref, 'KeyAttr option not defined returns original hash'); }

my $mock_object = mock 'XML::Simple' => (
    opt => { keyattr => { parent => ['key'] } },
    copy_hash => sub { my ($self, $hash, @args) = @_; return { %$hash, @args } },
);
my $result4 = eval { $mock_object->hash_to_array(undef, 'parent', $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { is(ref $result4, 'ARRAY', 'KeyAttr option defined returns array reference'); }

my $large_hash = {};
for (my $i = 0; $i < 1000; $i++) {
    $large_hash->{"key$i"} = { subkey => "value$i" };
}
my $result5 = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $large_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is(ref $result5, 'ARRAY', 'Large input hash returns array reference'); }

done_testing();