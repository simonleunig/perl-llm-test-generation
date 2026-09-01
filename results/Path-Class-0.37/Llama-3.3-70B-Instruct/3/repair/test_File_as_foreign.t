use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::as_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'as_foreign is defined'); }

# Test case 1: Valid foreign type
my $file = Path::Class::File->new('test.txt');
my $result = eval { $file->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(defined $result, 'as_foreign returns result for valid foreign type'); }

# Test case 2: Invalid foreign type
my $result2 = eval { $file->as_foreign('InvalidType') };
if ($@) { ok(1, 'as_foreign throws exception for invalid foreign type'); } else { fail('as_foreign did not throw exception for invalid foreign type'); }

# Test case 3: Undefined dir attribute
my $file2 = Path::Class::File->new('test.txt');
delete $file2->{dir};
my $result3 = eval { $file2->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(defined $result3, 'as_foreign returns result for undefined dir attribute'); }

# Test case 4: Defined dir attribute
my $file3 = Path::Class::File->new('test.txt');
$file3->{dir} = Path::Class::Dir->new('/path/to/dir');
my $result4 = eval { $file3->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(defined $result4, 'as_foreign returns result for defined dir attribute'); }

done_testing();
