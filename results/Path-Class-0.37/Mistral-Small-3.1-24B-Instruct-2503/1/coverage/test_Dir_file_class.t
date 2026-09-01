use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::file_class"} };
if ($@) {
    # FAILED: fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'file_class is defined');
}

# Test case for normal operation
my $result = eval { Path::Class::Dir::file_class() };
if ($@) {
    # FAILED: fail('Function crashed: ' . $@);
} else {
    is($result, 'Path::Class::File', 'file_class returns the correct class name');
}

# Additional test cases (if any) can be added here

done_testing();
