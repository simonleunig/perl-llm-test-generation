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
my $mock_carp;
eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::croak"}) {
        $mock_carp = mock 'Carp' => (
            override => [
                croak => sub { die shift },
                carp  => sub { warn shift },
            ]
        );
    } else {
        $mock_carp = mock 'Carp' => (
            add => [
                croak => sub { die shift },
                carp  => sub { warn shift },
            ]
        );
    }
}

my $mock_warnings;
eval { require warnings::register; };
if ($@) {
    # DEPENDENCY MISSING: warnings::register - mock skipped
} else {
    no strict 'refs';
    if (defined &{"warnings::register::enabled"}) {
        $mock_warnings = mock 'warnings::register' => (
            override => [
                enabled => sub { return 1 },
            ]
        );
    } else {
        $mock_warnings = mock 'warnings::register' => (
            add => [
                enabled => sub { return 1 },
            ]
        );
    }
}

# Test case 1: Strict mode enabled
{
    my $self = bless { opt => { strictmode => 1 } }, 'XML::Simple';
    my $msg = 'Test error message';

    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) { is($@, "Test error message", 'die_or_warn dies with message in strict mode'); } else { fail('die_or_warn did not die in strict mode'); }
}

# Test case 2: Warnings enabled, strict mode disabled
{
    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test warning message';

    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    if ($@) { like($@, qr/Warning: Test warning message/, 'die_or_warn issues warning in warning mode'); } else { fail('die_or_warn did not issue warning'); }
}

# Test case 3: No action (strict mode and warnings disabled)
{
    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test silent message';

    mock 'warnings::register' => (
        enabled => sub { return 0 },
    );

    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    is($@, '', 'die_or_warn does nothing when warnings and strict mode are disabled');
}

done_testing();