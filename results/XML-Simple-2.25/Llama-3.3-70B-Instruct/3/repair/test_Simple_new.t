use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

my $result = eval { XML::Simple->new('key' => 'value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid options'); }

my $odd_args_result = eval { XML::Simple->new('key') };
if ($@) { like($@, qr/Default options must be name=>value pairs/, 'Correct error message for odd number of arguments'); } else { fail('Expected error for odd number of arguments'); }

my $unrecognized_option_result = eval { XML::Simple->new('invalid_key' => 'value') };
if ($@) { like($@, qr/Unrecognised option: invalid_key/, 'Correct error message for unrecognized option'); } else { fail('Expected error for unrecognized option'); }

my $strict_mode_default_result = eval { XML::Simple->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $strict_mode_default_result, 'Function returns result with default strict mode'); }

done_testing();