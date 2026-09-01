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

my $empty_hash;  # AFTER LAST PASS: my $empty_hash = {};
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $empty_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, $empty_hash, 'Empty hash returns original hash'); }

my $non_hash;  # AFTER LAST PASS: my $non_hash = { key => 'value' };
my $result2;  # AFTER LAST PASS: my $result2;  # UNVALIDATED: my $result2 = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $non_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result2, $non_hash, 'Non-hash values return original hash'); }

my $hashref;  # AFTER LAST PASS: my $hashref = { key1 => { subkey => 'value' } };
my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $hashref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result3, $hashref, 'KeyAttr option not defined returns original hash'); }

my $mock_object;  # AFTER LAST PASS: my $mock_object = mock 'XML::Simple' => (
    # AFTER LAST PASS: opt => { keyattr => { parent => ['key'] } },
    my ($self, $hash, @args);  # AFTER LAST PASS: copy_hash => sub { my ($self, $hash, @args) = @_; return { %$hash, @args } },
# AFTER LAST PASS: );
my $result4;  # AFTER LAST PASS: my $result4;  # UNVALIDATED: my $result4 = eval { $mock_object->hash_to_array(undef, 'parent', $hashref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is(ref $result4, 'ARRAY', 'KeyAttr option defined returns array reference'); }

my $large_hash;  # AFTER LAST PASS: my $large_hash = {};
my $i;  # AFTER LAST PASS: for (my $i = 0; $i < 1000; $i++) {
    # AFTER LAST PASS: $large_hash->{"key$i"} = { subkey => "value$i" };
# AFTER LAST PASS: }
my $result5;  # AFTER LAST PASS: my $result5;  # UNVALIDATED: my $result5 = eval { XML::Simple->hash_to_array(XML::Simple->new(), undef, $large_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is(ref $result5, 'ARRAY', 'Large input hash returns array reference'); }

done_testing();