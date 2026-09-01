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
eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::croak"}) {
        $mock = mock 'Carp' => ( override => [
            croak => sub { die shift },
            carp  => sub { warn shift },
        ]);
    } else {
        $mock = mock 'Carp' => ( add => [
            croak => sub { die shift },
            carp  => sub { warn shift },
        ]);
    }
}

eval { require warnings::register; };
if ($@) {
    # DEPENDENCY MISSING: warnings::register - mock skipped
} else {
    no strict 'refs';
    if (defined &{"warnings::register::enabled"}) {
        $mock = mock 'warnings::register' => ( override => [
            enabled => sub { return 1 },
        ]);
    } else {
        $mock = mock 'warnings::register' => ( add => [
            enabled => sub { return 1 },
        ]);
    }
}

# Test case 1: Strict mode enabled
{
    my $self = bless { opt => { strictmode => 1 } }, 'XML::Simple';
    my $msg = 'Test error message';

    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) {
        is($@, "Test error message", 'die_or_warn dies with the correct message in strict mode');
    } else {
        fail('die_or_warn did not die in strict mode');
    }
}

# Test case 2: Warnings enabled, strict mode disabled
{
    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test warning message';

    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) {
        fail('die_or_warn unexpectedly died');
    } else {
        is(warned(), 1, 'die_or_warn issues a warning');
        is(warned(), 'Warning: Test warning message', 'die_or_warn issues the correct warning message');
    }
}

# Test case 3: Neither strict mode nor warnings enabled
{
    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test silent message';

    mock 'warnings::register' => (
        enabled => sub { return 0 },
    );

    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) {
        fail('die_or_warn unexpectedly died');
    } else {
        is(warned(), 0, 'die_or_warn does nothing when neither strict mode nor warnings are enabled');
    }
}

done_testing();