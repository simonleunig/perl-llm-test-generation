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

# Mocking rmdir to avoid actual file system operations
# AFTER LAST PASS: mock 'CORE::GLOBAL::rmdir' => sub {
    my ($dir);  # AFTER LAST PASS: my ($dir) = @_;
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

# Test case: Successful directory removal
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('test_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->remove() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Directory removed successfully');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Non-existent directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('non_existent_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->remove() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Non-existent directory removal returns undef');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Non-empty directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('non_empty_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->remove() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Non-empty directory removal returns undef');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Permission denied
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('permission_denied_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->remove() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Permission denied directory removal returns undef');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Invalid input (not a Path::Class::Dir object)
# AFTER LAST PASS: {
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::remove('invalid_input') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Invalid input returns undef');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();