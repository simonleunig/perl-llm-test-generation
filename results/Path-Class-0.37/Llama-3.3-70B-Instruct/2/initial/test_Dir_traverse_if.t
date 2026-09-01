use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

# Create a temporary directory
my $temp_dir = tempdir(CLEANUP => 1);

# Create a Path::Class::Dir object
my $dir = Path::Class::Dir->new($temp_dir);

# Define a callback function
my $callback = sub {
    my ($self, $sub) = @_;
    return $sub->();
};

# Define a condition function
my $condition = sub {
    my ($file) = @_;
    return 1;  # Always return true for testing purposes
};

# Test case: traverse_if with a valid directory
my $result = eval { $dir->traverse_if($callback, $condition) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns result'); }

# Test case: traverse_if with an invalid directory
my $invalid_dir = Path::Class::Dir->new('/non/existent/directory');
$result = eval { $invalid_dir->traverse_if($callback, $condition) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(!defined $result, 'traverse_if returns undef for invalid directory'); }

# Test case: traverse_if with a condition that always returns false
my $false_condition = sub {
    my ($file) = @_;
    return 0;  # Always return false for testing purposes
};
$result = eval { $dir->traverse_if($callback, $false_condition) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(!defined $result, 'traverse_if returns undef when condition is always false'); }

done_testing();
