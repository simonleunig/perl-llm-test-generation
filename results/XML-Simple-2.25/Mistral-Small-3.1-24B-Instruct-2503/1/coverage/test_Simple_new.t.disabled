use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Mock dependencies
mock 'Carp' => ( croak => sub { die shift } );
mock 'Scalar::Util' => ();
mock 'File::Basename' => ();
mock 'XML::SAX' => ();
mock 'XML::Parser' => ();
mock 'Storable' => ();
mock 'XML::NamespaceSupport' => ();
mock 'IO::Handle' => ();
mock 'File::Spec' => ();

# Mock internal functions and variables
mock 'XML::Simple' => (
    _strict_mode_for_caller => sub { return 1 },
    @KnownOptIn => ['opt1', 'opt2'],
    @KnownOptOut => ['opt3', 'opt4']
);

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case: Valid options
my $result = eval { XML::Simple->new('opt1' => 1, 'opt2' => 2) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with valid options');
    isa_ok($result, 'XML::Simple', 'Result is an XML::Simple object');
    is($result->{def_opt}{opt1}, 1, 'Option opt1 is set correctly');
    is($result->{def_opt}{opt2}, 2, 'Option opt2 is set correctly');
}

# Test case: Odd number of arguments
$result = eval { XML::Simple->new('opt1' => 1, 'opt2') };
if ($@) { like($@, qr/odd number supplied/, 'Function croaks with odd number of arguments'); }

# Test case: Unrecognized option
$result = eval { XML::Simple->new('opt1' => 1, 'unknown' => 2) };
if ($@) { like($@, qr/Unrecognised option/, 'Function croaks with unrecognized option'); }

# Test case: Default strictmode
$result = eval { XML::Simple->new('opt1' => 1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with default strictmode');
    is($result->{def_opt}{strictmode}, 1, 'Default strictmode is set correctly');
}

# Test case: Provided strictmode
$result = eval { XML::Simple->new('opt1' => 1, 'strictmode' => 0) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with provided strictmode');
    is($result->{def_opt}{strictmode}, 0, 'Provided strictmode is set correctly');
}

done_testing();