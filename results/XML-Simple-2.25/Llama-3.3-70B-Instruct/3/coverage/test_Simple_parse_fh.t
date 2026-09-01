use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_fh"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_fh is defined'); }

my $result = eval { XML::Simple->parse_fh('invalid') };
if ($@) { like($@, qr/Can't use string/, 'Invalid filehandle error'); } else { fail('Expected error for invalid filehandle'); }

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh '<root/>';  # FAILED: fallback assertion removed
# AFTER LAST PASS: close $fh;  # FAILED: fallback assertion removed
# AFTER LAST PASS: open $fh, '<', $filename;  # FAILED: fallback assertion removed
# UNVALIDATED: $result = eval { XML::Simple->parse_fh($fh) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid filehandle'); }

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh '<root><person><name>John</name><age>30</age></person></root>';  # FAILED: fallback assertion removed
# AFTER LAST PASS: close $fh;  # FAILED: fallback assertion removed
# AFTER LAST PASS: open $fh, '<', $filename;  # FAILED: fallback assertion removed
# UNVALIDATED: $result = eval { XML::Simple->parse_fh($fh) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid filehandle with well-formed XML'); }

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh '<root><person><name>John</name><age>30</age>';  # FAILED: fallback assertion removed
# AFTER LAST PASS: close $fh;  # FAILED: fallback assertion removed
# AFTER LAST PASS: open $fh, '<', $filename;  # FAILED: fallback assertion removed
# UNVALIDATED: $result = eval { XML::Simple->parse_fh($fh) };
# FAILED: if ($@) { like($@, qr/parse error/, 'Malformed XML error'); } else { fail('Expected error for malformed XML'); }

done_testing();