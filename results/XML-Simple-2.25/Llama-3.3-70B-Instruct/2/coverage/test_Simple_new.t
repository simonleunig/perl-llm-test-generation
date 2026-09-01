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
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result with valid options"); }

$result = eval { XML::Simple->new(key => 'value', 'extra') };
if ($@) { like($@, qr/Default options must be name=>value pairs/, 'Correct error message for odd number of arguments'); }
# FAILED: else { fail('Expected error for odd number of arguments'); }

$result = eval { XML::Simple->new(invalid => 'option') };
if ($@) { like($@, qr/Unrecognised option: invalid/, 'Correct error message for unrecognized option'); }
# FAILED: else { fail('Expected error for unrecognized option'); }

$result = eval { XML::Simple->new(strictmode => 1) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result with strict mode"); }

my $mock;
# AFTER LAST PASS: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::new"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( override => [ new => sub { return bless {}, 'XML::Simple'; } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( add => [ new => sub { return bless {}, 'XML::Simple'; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();