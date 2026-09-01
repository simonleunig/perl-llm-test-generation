use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::storable_filename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'storable_filename is defined'); }

my $result1 = eval { XML::Simple->storable_filename('test.xml') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result1, 'test.xml.stor', 'storable_filename with .xml extension'); }

my $result2 = eval { XML::Simple->storable_filename('test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'test.stor', 'storable_filename without .xml extension'); }

my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { XML::Simple->storable_filename(undef) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result3, undef, 'storable_filename with undef input'); }

my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { XML::Simple->storable_filename(undef) };
# FAILED: ok($@, "Dies with undef input");
# FAILED: like($@, qr/Use of uninitialized value/, "Error message correct");

done_testing();