use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "new is defined"); }

my $result = eval { XML::Simple->new(key => 'value') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result with valid options"); }

$result = eval { XML::Simple->new(key => 'value', 'extra') };
if ($@) { like($@, qr/Default options must be name=>value pairs/, 'Correct error message for odd number of arguments'); }
else { fail('Expected error for odd number of arguments'); }

$result = eval { XML::Simple->new(invalid => 'option') };
if ($@) { like($@, qr/Unrecognised option: invalid/, 'Correct error message for unrecognized option'); }
else { fail('Expected error for unrecognized option'); }

$result = eval { XML::Simple->new(strictmode => 1) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result with strict mode"); }

my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::new"}) {
        $mock = mock 'XML::Simple' => ( override => [ new => sub { return bless {}, 'XML::Simple'; } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ new => sub { return bless {}, 'XML::Simple'; } ] );
    }
}

done_testing();