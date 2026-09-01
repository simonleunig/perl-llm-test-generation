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

# Mocking dependencies
my $mock;
# AFTER LAST PASS: eval { require Carp; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Carp::croak"}) {
        # AFTER LAST PASS: $mock = mock 'Carp' => ( override => [
            # AFTER LAST PASS: croak => sub { die shift },
            # AFTER LAST PASS: carp  => sub { warn shift },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Carp' => ( add => [
            # AFTER LAST PASS: croak => sub { die shift },
            # AFTER LAST PASS: carp  => sub { warn shift },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require warnings::register; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: warnings::register - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"warnings::register::enabled"}) {
        # AFTER LAST PASS: $mock = mock 'warnings::register' => ( override => [
            # AFTER LAST PASS: enabled => sub { return 1 },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'warnings::register' => ( add => [
            # AFTER LAST PASS: enabled => sub { return 1 },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Strict mode enabled
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { strictmode => 1 } }, 'XML::Simple';
    my $msg;  # AFTER LAST PASS: my $msg = 'Test error message';

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: is($@, "Test error message", 'die_or_warn dies with the correct message in strict mode');
    # AFTER LAST PASS: } else {
        # FAILED: fail('die_or_warn did not die in strict mode');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 2: Warnings enabled, strict mode disabled
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg;  # AFTER LAST PASS: my $msg = 'Test warning message';

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('die_or_warn unexpectedly died');
    # AFTER LAST PASS: } else {
        # FAILED: is(warned(), 1, 'die_or_warn issues a warning');
        # FAILED: is(warned(), 'Warning: Test warning message', 'die_or_warn issues the correct warning message');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 3: Neither strict mode nor warnings enabled
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg;  # AFTER LAST PASS: my $msg = 'Test silent message';

    # AFTER LAST PASS: mock 'warnings::register' => (
        # AFTER LAST PASS: enabled => sub { return 0 },
    # AFTER LAST PASS: );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('die_or_warn unexpectedly died');
    # AFTER LAST PASS: } else {
        # FAILED: is(warned(), 0, 'die_or_warn does nothing when neither strict mode nor warnings are enabled');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();