use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree is defined'); }

# Test case 1: Successful parsing with XML::SAX
my $simple = bless({}, 'XML::Simple');
my $temp_file = tempfile();
print $temp_file "<root><foo>bar</foo></root>";
seek $temp_file, 0, 0;
my $result = eval { $simple->build_tree($temp_file->filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with XML::SAX'); }

# Test case 2: Successful parsing with XML::Parser
my $mock = mock 'XML::SAX' => (
    tracker => sub { $@ = 'Mocked XML::SAX error'; },
    override => [ parse_uri => sub { return {} } ],
);
my $result_parser = eval { $simple->build_tree($temp_file->filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_parser, 'Function returns result with XML::Parser'); }

# Test case 3: Error handling with invalid XML
my $invalid_temp_file = tempfile();
print $invalid_temp_file "<root><foo>bar";
seek $invalid_temp_file, 0, 0;
my $error_result = eval { $simple->build_tree($invalid_temp_file->filename) };
if ($@) { ok(1, 'Function raises error with invalid XML'); } else { fail('Function did not raise error with invalid XML'); }

# Test case 4: Error handling with missing XML::SAX
my $mock_sax = mock 'XML::SAX' => (
    tracker => sub { $@ = 'Mocked XML::SAX error'; },
);
my $error_result_sax = eval { $simple->build_tree($temp_file->filename) };
if ($@) { ok(1, 'Function raises error with missing XML::SAX'); } else { fail('Function did not raise error with missing XML::SAX'); }

done_testing();
