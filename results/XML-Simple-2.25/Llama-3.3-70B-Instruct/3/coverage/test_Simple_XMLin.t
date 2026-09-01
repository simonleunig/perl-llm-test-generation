use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLin"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLin is defined'); }

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->XMLin(undef); };
# FAILED: if ($@) { fail('XMLin crashed with undefined target: ' . $@); } else { ok(defined $result, 'XMLin returns result with undefined target'); }

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh '<root><foo>bar</foo></root>';
# AFTER LAST PASS: seek $fh, 0, 0;
my $stdin_mock;  # AFTER LAST PASS: my $stdin_mock = mock 'IO::Handle' => ( tie => sub { return $fh } );
# AFTER LAST PASS: local *STDIN = $stdin_mock->handle;
# UNVALIDATED: $result = eval { XML::Simple->XMLin('-'); };
# FAILED: if ($@) { fail('XMLin crashed with target \'-\': ' . $@); } else { ok(defined $result, 'XMLin returns result with target \'-\''); }

my $scalar_ref;  # AFTER LAST PASS: my $scalar_ref = \'<root><foo>bar</foo></root>';
# UNVALIDATED: $result = eval { XML::Simple->XMLin($scalar_ref); };
# FAILED: if ($@) { fail('XMLin crashed with scalar reference target: ' . $@); } else { ok(defined $result, 'XMLin returns result with scalar reference target'); }

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh '<root><foo>bar</foo></root>';
# AFTER LAST PASS: seek $fh, 0, 0;
# UNVALIDATED: $result = eval { XML::Simple->XMLin($fh); };
# FAILED: if ($@) { fail('XMLin crashed with filehandle target: ' . $@); } else { ok(defined $result, 'XMLin returns result with filehandle target'); }

my $xml_string;  # AFTER LAST PASS: my $xml_string = '<root><foo>bar</foo></root>';
# UNVALIDATED: $result = eval { XML::Simple->XMLin($xml_string); };
# FAILED: if ($@) { fail('XMLin crashed with XML string target: ' . $@); } else { ok(defined $result, 'XMLin returns result with XML string target'); }

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh '<root><foo>bar</foo></root>';
# AFTER LAST PASS: close $fh;
# UNVALIDATED: $result = eval { XML::Simple->XMLin($filename); };
# FAILED: if ($@) { fail('XMLin crashed with filename target: ' . $@); } else { ok(defined $result, 'XMLin returns result with filename target'); }

done_testing();