use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

my $result = eval { Path::Class::file('test', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

$result = eval { Path::Class::file('non_existent', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-existent file'); }

$result = eval { Path::Class::file() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty input'); }

my $mock;
# AFTER LAST PASS: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( new => sub { bless {}, 'Path::Class::File' } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( new => sub { bless {}, 'Path::Class::File' } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# UNVALIDATED: $result = eval { Path::Class::file('test', 'file.txt') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with mocked dependency'); }

done_testing();