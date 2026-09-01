use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::characters"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'characters is defined'); }

# Test case 1: Empty $chars hash reference
my $self = bless {}, 'XML::Simple';
my $chars = {};
my $result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty $chars'); }

# Test case 2: Undefined $chars hash reference
$chars = undef;
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined $chars'); }

# Test case 3: $chars hash reference with non-string Data
$chars = { Data => 123 };
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-string Data'); }

# Test case 4: $chars hash reference with string Data
$chars = { Data => 'test' };
$self->{curlist} = [];
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for string Data'); }

# Test case 5: $self->{curlist} is not initialized
delete $self->{curlist};
$chars = { Data => 'test' };
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for uninitialized $self->{curlist}'); }

# Test case 6: $self->{curlist} is empty
$self->{curlist} = [];
$chars = { Data => 'test' };
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty $self->{curlist}'); }

# Test case 7: $self->{curlist} has one element
$self->{curlist} = [0 => 'test'];
$chars = { Data => 'test' };
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for $self->{curlist} with one element'); }

# Test case 8: $self->{curlist} has multiple elements
$self->{curlist} = [0 => 'test', 1 => 'test2'];
$chars = { Data => 'test' };
$result = eval { XML::Simple::characters($self, $chars) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for $self->{curlist} with multiple elements'); }

done_testing();
