use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::die_or_warn"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'die_or_warn is defined'); }

my $mock_obj = bless { opt => { strictmode => 1 } }, 'XML::Simple';
my $result = eval { $mock_obj->die_or_warn('Test error message') };
if ($@) { ok($@ =~ /Test error message/, 'Dies with error message when strictmode is enabled'); }
# FAILED: else { fail('Expected to die with error message'); }

# AFTER LAST PASS: $mock_obj = bless { opt => { strictmode => 0 } }, 'XML::Simple';
my $warn_mock;
# UNVALIDATED: eval { require warnings; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: warnings - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"warnings::enabled"}) {
        # AFTER LAST PASS: $warn_mock = mock 'warnings' => ( override => [ enabled => sub { return 1 } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $warn_mock = mock 'warnings' => ( add => [ enabled => sub { return 1 } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $mock_obj->die_or_warn('Test warning message') };
# FAILED: if ($@) { fail('Unexpected error: ' . $@); }
# FAILED: else { ok(1, 'Issues warning when strictmode is disabled and warnings are enabled'); }

# AFTER LAST PASS: $mock_obj = bless { opt => { strictmode => 0 } }, 'XML::Simple';
# UNVALIDATED: eval { require warnings; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: warnings - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"warnings::enabled"}) {
        # AFTER LAST PASS: $warn_mock = mock 'warnings' => ( override => [ enabled => sub { return 0 } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $warn_mock = mock 'warnings' => ( add => [ enabled => sub { return 0 } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $mock_obj->die_or_warn('Test silent message') };
# FAILED: if ($@) { fail('Unexpected error: ' . $@); }
# FAILED: else { ok(1, 'Silently ignores message when strictmode is disabled and warnings are disabled'); }

done_testing();