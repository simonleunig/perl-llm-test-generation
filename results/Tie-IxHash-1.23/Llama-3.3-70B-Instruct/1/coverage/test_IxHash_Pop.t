use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Pop() };
if ($@) { fail('Pop on empty hash crashed: ' . $@); } else { is($result, undef, 'Pop on empty hash returns undef'); }

# AFTER LAST PASS: $ixhash->Push('key1', 'value1');
# UNVALIDATED: $result = eval { $ixhash->Pop() };
# FAILED: if ($@) { fail('Pop on hash with one element crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Pop on hash with one element returns correct key-value pair'); }

# AFTER LAST PASS: $ixhash->Push('key2', 'value2');
# AFTER LAST PASS: $ixhash->Push('key3', 'value3');
# UNVALIDATED: $result = eval { $ixhash->Pop() };
# FAILED: if ($@) { fail('Pop on hash with multiple elements crashed: ' . $@); } else { is_deeply($result, ['key3', 'value3'], 'Pop on hash with multiple elements returns correct key-value pair'); }

# UNVALIDATED: $result = eval { $ixhash->Pop() };
# FAILED: if ($@) { fail('Second Pop crashed: ' . $@); } else { is_deeply($result, ['key2', 'value2'], 'Second Pop returns correct key-value pair'); }
# UNVALIDATED: $result = eval { $ixhash->Pop() };
# FAILED: if ($@) { fail('Third Pop crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Third Pop returns correct key-value pair'); }
# UNVALIDATED: $result = eval { $ixhash->Pop() };
# FAILED: if ($@) { fail('Fourth Pop crashed: ' . $@); } else { is($result, undef, 'Fourth Pop returns undef'); }

done_testing();