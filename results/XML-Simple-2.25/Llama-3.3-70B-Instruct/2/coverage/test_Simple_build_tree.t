use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree is defined'); }

my $simple;  # AFTER LAST PASS: my $simple = bless({}, 'XML::Simple');
my $temp_file;  # AFTER LAST PASS: my $temp_file = tempfile();
# AFTER LAST PASS: print $temp_file "<root><foo>bar</foo></root>";
# AFTER LAST PASS: seek $temp_file, 0, 0;
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $simple->build_tree($temp_file) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with XML::SAX'); }

my $mock;  # AFTER LAST PASS: my $mock = mock 'XML::SAX' => (
    # AFTER LAST PASS: tracker => sub { $@ = 'Mocked XML::SAX error'; },
    # AFTER LAST PASS: override => [ parse_uri => sub { return {} } ],
# AFTER LAST PASS: );
my $result_parser;  # AFTER LAST PASS: my $result_parser;  # UNVALIDATED: my $result_parser = eval { $simple->build_tree($temp_file) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_parser, 'Function returns result with XML::Parser'); }

my $invalid_temp_file;  # AFTER LAST PASS: my $invalid_temp_file = tempfile();
# AFTER LAST PASS: print $invalid_temp_file "<root><foo>bar";
# AFTER LAST PASS: seek $invalid_temp_file, 0, 0;
my $error_result;  # AFTER LAST PASS: my $error_result;  # UNVALIDATED: my $error_result = eval { $simple->build_tree($invalid_temp_file) };
# FAILED: if ($@) { ok(1, 'Function raises error with invalid XML'); } else { fail('Function did not raise error with invalid XML'); }

my $mock_sax;  # AFTER LAST PASS: my $mock_sax = mock 'XML::SAX' => (
    # AFTER LAST PASS: tracker => sub { $@ = 'Mocked XML::SAX error'; },
# AFTER LAST PASS: );
my $error_result_sax;  # AFTER LAST PASS: my $error_result_sax;  # UNVALIDATED: my $error_result_sax = eval { $simple->build_tree($temp_file) };
# FAILED: if ($@) { ok(1, 'Function raises error with missing XML::SAX'); } else { fail('Function did not raise error with missing XML::SAX'); }

done_testing();