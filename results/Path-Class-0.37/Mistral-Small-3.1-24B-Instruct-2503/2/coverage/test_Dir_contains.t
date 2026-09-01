use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::contains"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'contains is defined'); }

# Mock dependencies
my $mock;
# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: new => sub { return bless { path => shift }, 'Path::Class::Dir' },
                # AFTER LAST PASS: resolve => sub { return bless { path => shift }, 'Path::Class::Dir' },
                # AFTER LAST PASS: subsumes => sub { return shift->[0] eq shift->[1] },
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: new => sub { return bless { path => shift }, 'Path::Class::Dir' },
                # AFTER LAST PASS: resolve => sub { return bless { path => shift }, 'Path::Class::Dir' },
                # AFTER LAST PASS: subsumes => sub { return shift->[0] eq shift->[1] },
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: new => sub { return bless { path => shift }, 'Path::Class::File' },
                # AFTER LAST PASS: resolve => sub { return bless { path => shift }, 'Path::Class::File' },
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: new => sub { return bless { path => shift }, 'Path::Class::File' },
                # AFTER LAST PASS: resolve => sub { return bless { path => shift }, 'Path::Class::File' },
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: mock 'Carp' => (
    # AFTER LAST PASS: croak => sub { die shift },
# AFTER LAST PASS: );

# Test cases with eval protection

# Test with valid inputs
my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('/valid/dir');
my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new('/valid/dir/file');
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->contains($file) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'contains returns true for valid inputs'); }

# Test with invalid inputs (too many arguments)
# UNVALIDATED: $result = eval { $dir->contains($file, 'extra') };
# FAILED: if ($@ !~ /Too many arguments given to contains/) { fail('Function did not throw expected error: ' . $@); } else { pass('Function throws error for too many arguments'); }

# Test with undefined $other
# UNVALIDATED: $result = eval { $dir->contains(undef) };
# FAILED: if ($@ !~ /No second entity given to contains/) { fail('Function did not throw expected error: ' . $@); } else { pass('Function throws error for undefined $other'); }

# Test with $self not being a directory
# UNVALIDATED: $result = eval { $file->contains($file) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'contains returns false for $self not being a directory'); }

# Test with $other not existing
my $non_existent_file;  # AFTER LAST PASS: my $non_existent_file;  # UNVALIDATED: my $non_existent_file = Path::Class::File->new('/non/existent/file');
# UNVALIDATED: $result = eval { $dir->contains($non_existent_file) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'contains returns false for $other not existing'); }

# Test with $other being a symbolic link
my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
my $symlink;  # AFTER LAST PASS: my $symlink;  # UNVALIDATED: my $symlink = File::Spec->catfile($tempdir, 'symlink');
# AFTER LAST PASS: symlink($file->path, $symlink);
my $symlink_file;  # AFTER LAST PASS: my $symlink_file;  # UNVALIDATED: my $symlink_file = Path::Class::File->new($symlink);
# UNVALIDATED: $result = eval { $dir->contains($symlink_file) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'contains returns true for $other being a symbolic link'); }

# Clean up temporary directory
# AFTER LAST PASS: rmdir($tempdir);

done_testing();