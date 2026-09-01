use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::die_or_warn"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'die_or_warn is defined'); }

# Test case 1: strictmode enabled
my $mock_obj = bless { opt => { strictmode => 1 } }, 'XML::Simple';
my $result = eval { $mock_obj->die_or_warn('Test error message') };
if ($@) { ok($@ =~ /Test error message/, 'Dies with error message when strictmode is enabled'); }
else { fail('Expected to die with error message'); }

# Test case 2: strictmode disabled and warnings enabled
$mock_obj = bless { opt => { strictmode => 0 } }, 'XML::Simple';
my $warn_mock = mock 'warnings' => (
    enabled => sub { return 1 },
);
$result = eval { $mock_obj->die_or_warn('Test warning message') };
if ($@) { fail('Unexpected error: ' . $@); }
else { ok(1, 'Issues warning when strictmode is disabled and warnings are enabled'); }

# Test case 3: strictmode disabled and warnings disabled
$mock_obj = bless { opt => { strictmode => 0 } }, 'XML::Simple';
$warn_mock = mock 'warnings' => (
    enabled => sub { return 0 },
);
$result = eval { $mock_obj->die_or_warn('Test warning message') };
if ($@) { fail('Unexpected error: ' . $@); }
else { ok(1, 'Silently ignores error message when strictmode is disabled and warnings are disabled'); }

done_testing();
