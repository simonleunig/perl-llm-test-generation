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
eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::croak"}) {
        $mock_carp = mock 'Carp' => ( override => [
            croak => sub { die shift },
            carp  => sub { warn shift },
        ]);
    } else {
        $mock_carp = mock 'Carp' => ( add => [
            croak => sub { die shift },
            carp  => sub { warn shift },
        ]);
    }
}

my $mock_warnings;
eval { require warnings; };
if ($@) {
    # DEPENDENCY MISSING: warnings - mock skipped
} else {
    no strict 'refs';
    if (defined &{"warnings::enabled"}) {
        $mock_warnings = mock 'warnings' => ( override => [
            enabled => sub { return 1 },
        ]);
    } else {
        $mock_warnings = mock 'warnings' => ( add => [
            enabled => sub { return 1 },
        ]);
    }
}

# Test case 1: strictmode enabled, should die
{
    my $self = bless { opt => { strictmode => 1 } }, 'XML::Simple';
    my $msg = 'Test error message';
    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) {
        is($@, "Test error message", 'die_or_warn dies with strictmode enabled');
    } else {
        fail('die_or_warn did not die with strictmode enabled');
    }
}

# Test case 2: warnings enabled, strictmode disabled, should warn
{
    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test warning message';
    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) {
        fail('die_or_warn died unexpectedly');
    } else {
        is($@, '', 'die_or_warn does not die with warnings enabled and strictmode disabled');
        like($@, qr/Warning: Test warning message/, 'die_or_warn issues a warning');
    }
}

# Test case 3: neither strictmode nor warnings enabled, should do nothing
{
    mock 'warnings' => (
        enabled => sub { return 0 },
    );

    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test silent message';
    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) {
        fail('die_or_warn died unexpectedly');
    } else {
        is($@, '', 'die_or_warn does nothing with neither strictmode nor warnings enabled');
    }
}

done_testing();