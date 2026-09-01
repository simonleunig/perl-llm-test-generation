use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::die_or_warn"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'die_or_warn is defined'); }

# Mocking dependencies
mock 'Carp' => (
    croak => sub { die shift },
    carp  => sub { warn shift },
);

mock 'warnings' => (
    enabled => sub { return 1 },
);

# Test case 1: strictmode enabled, should die
{
    my $self = bless { opt => { strictmode => 1 } }, 'XML::Simple';
    my $msg = 'Test error message';
    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    is($@, "Test error message", 'die_or_warn dies with strictmode enabled');
}

# Test case 2: warnings enabled, strictmode disabled, should warn
{
    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test warning message';
    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    is($@, '', 'die_or_warn does not die with warnings enabled and strictmode disabled');
    like($@, qr/Warning: Test warning message/, 'die_or_warn issues a warning');
}

# Test case 3: neither strictmode nor warnings enabled, should do nothing
{
    mock 'warnings' => (
        enabled => sub { return 0 },
    );

    my $self = bless { opt => { strictmode => 0 } }, 'XML::Simple';
    my $msg = 'Test silent message';
    my $result = eval { XML::Simple::die_or_warn($self, $msg) };
    is($@, '', 'die_or_warn does nothing with neither strictmode nor warnings enabled');
}

done_testing();
