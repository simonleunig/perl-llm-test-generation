use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

# Test case: Check if traverse_if returns a result
my $result = eval { Path::Class::File->new()->traverse_if(sub { }, sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns a result'); }

# Test case: Check if traverse_if handles invalid callback
my $invalid_callback_result = eval { Path::Class::File->new()->traverse_if('invalid_callback', sub { 1 }, 'arg1', 'arg2') };
if ($@) { like($@, qr/Can't locate object method/, 'traverse_if handles invalid callback'); } else { fail('traverse_if did not handle invalid callback'); }

# Test case: Check if traverse_if handles invalid condition
my $invalid_condition_result = eval { Path::Class::File->new()->traverse_if(sub { }, 'invalid_condition', 'arg1', 'arg2') };
if ($@) { like($@, qr/Type of argument/, 'traverse_if handles invalid condition'); } else { fail('traverse_if did not handle invalid condition'); }

done_testing();
