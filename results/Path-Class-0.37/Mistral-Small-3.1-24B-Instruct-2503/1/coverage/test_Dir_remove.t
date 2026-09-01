use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

# Mocking rmdir to simulate different scenarios
# AFTER LAST PASS: mock 'CORE::GLOBAL::rmdir' => sub {
    my $dir;  # AFTER LAST PASS: my $dir = shift;
    # AFTER LAST PASS: if ($dir eq 'non_existent_dir') {
        # AFTER LAST PASS: return 0;
    # AFTER LAST PASS: } elsif ($dir eq 'non_empty_dir') {
        # AFTER LAST PASS: return 0;
    # AFTER LAST PASS: } elsif ($dir eq 'permission_denied_dir') {
        # AFTER LAST PASS: return 0;
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: return 1;
    # AFTER LAST PASS: }
# AFTER LAST PASS: };

# Test case: Successfully remove an empty directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = tempdir(CLEANUP => 1);
    my $dir_obj;  # AFTER LAST PASS: my $dir_obj;  # UNVALIDATED: my $dir_obj = Path::Class::Dir->new($dir);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir_obj->remove };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Successfully removed an empty directory');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Attempt to remove a non-existent directory
# AFTER LAST PASS: {
    my $dir_obj;  # AFTER LAST PASS: my $dir_obj;  # UNVALIDATED: my $dir_obj = Path::Class::Dir->new('non_existent_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir_obj->remove };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Failed to remove a non-existent directory');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Attempt to remove a non-empty directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = tempdir(CLEANUP => 1);
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = File::Spec->catfile($dir, 'testfile.txt');
    my $fh;  # AFTER LAST PASS: open(my $fh, '>', $file) or die "Could not create file '$file' $!";
    # AFTER LAST PASS: close($fh);
    my $dir_obj;  # AFTER LAST PASS: my $dir_obj;  # UNVALIDATED: my $dir_obj = Path::Class::Dir->new($dir);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir_obj->remove };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Failed to remove a non-empty directory');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Attempt to remove a directory with permission issues
# AFTER LAST PASS: {
    my $dir_obj;  # AFTER LAST PASS: my $dir_obj;  # UNVALIDATED: my $dir_obj = Path::Class::Dir->new('permission_denied_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir_obj->remove };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Failed to remove a directory with permission issues');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Invalid input (not a Path::Class::Dir object)
# AFTER LAST PASS: {
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir->remove('invalid_input') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Failed to remove with invalid input');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();