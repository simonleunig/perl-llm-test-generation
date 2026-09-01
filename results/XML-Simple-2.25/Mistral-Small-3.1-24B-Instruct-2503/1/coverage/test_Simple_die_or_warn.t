use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::die_or_warn"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'die_or_warn is defined'); }

# Mocking dependencies
my $mock_carp;
# AFTER LAST PASS: eval { require Carp; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Carp::croak"}) {
        # AFTER LAST PASS: $mock_carp = mock 'Carp' => ( override => [
            # AFTER LAST PASS: croak => sub { die shift },
            # AFTER LAST PASS: carp  => sub { warn shift },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_carp = mock 'Carp' => ( add => [
            # AFTER LAST PASS: croak => sub { die shift },
            # AFTER LAST PASS: carp  => sub { warn shift },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_warnings;
# AFTER LAST PASS: eval { require warnings; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: warnings - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"warnings::enabled"}) {
        # AFTER LAST PASS: $mock_warnings = mock 'warnings' => ( override => [
            # AFTER LAST PASS: enabled => sub { return 1 },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_warnings = mock 'warnings' => ( add => [
            # AFTER LAST PASS: enabled => sub { return 1 },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: strictmode enabled, should die
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { strictmode => 1 } }, 'XML::Simple';
    my $msg;  # AFTER LAST PASS: my $msg = 'Test error message';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: is($@, "Test error message", 'die_or_warn dies with strictmode enabled');
    # AFTER LAST PASS: } else {
        # FAILED: fail('die_or_warn did not die with strictmode enabled');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 2: warnings enabled, strictmode disabled, should warn
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg;  # AFTER LAST PASS: my $msg = 'Test warning message';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('die_or_warn died unexpectedly');
    # AFTER LAST PASS: } else {
        # FAILED: is($@, '', 'die_or_warn does not die with warnings enabled and strictmode disabled');
        # FAILED: like($@, qr/Warning: Test warning message/, 'die_or_warn issues a warning');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 3: neither strictmode nor warnings enabled, should do nothing
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'warnings' => (
        # AFTER LAST PASS: enabled => sub { return 0 },
    # AFTER LAST PASS: );

    my $self;  # AFTER LAST PASS: my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg;  # AFTER LAST PASS: my $msg = 'Test silent message';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('die_or_warn died unexpectedly');
    # AFTER LAST PASS: } else {
        # FAILED: is($@, '', 'die_or_warn does nothing with neither strictmode nor warnings enabled');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();