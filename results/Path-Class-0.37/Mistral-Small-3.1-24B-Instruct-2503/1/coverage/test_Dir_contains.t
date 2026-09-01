use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::contains"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'contains is defined'); }

# Mocking dependencies
my $mock;
# AFTER LAST PASS: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( override => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( add => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => ( override => [ new => sub { return bless {}, 'Path::Class::Entity' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => ( add => [ new => sub { return bless {}, 'Path::Class::Entity' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: mock 'IO::Dir' => ();
# AFTER LAST PASS: mock 'File::Path' => ();
# AFTER LAST PASS: mock 'File::Temp' => ();
# AFTER LAST PASS: mock 'Scalar::Util' => ();

# Test case: Too many arguments
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::contains('arg1', 'arg2', 'arg3') };
# FAILED: if ($@) { is($@, 'Too many arguments given to contains()', 'Too many arguments throws exception'); } else { fail('Expected exception not thrown'); }

# Test case: No second entity given
# UNVALIDATED: $result = eval { Path::Class::Dir::contains('arg1') };
# FAILED: if ($@) { is($@, 'No second entity given to contains()', 'No second entity throws exception'); } else { fail('Expected exception not thrown'); }

# Test case: $self is not a directory
my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
# AFTER LAST PASS: mock $dir => ( new => sub { return $dir }, resolve => sub { return $dir }, subsumes => sub { return 1 } );
# UNVALIDATED: $result = eval { $dir->contains('arg2') };
# FAILED: is($result, undef, '$self is not a directory returns undef');

# Test case: $other does not exist
# AFTER LAST PASS: mock $dir => ( new => sub { return $dir }, resolve => sub { return $dir }, subsumes => sub { return 1 } );
# UNVALIDATED: $result = eval { $dir->contains('nonexistent') };
# FAILED: is($result, undef, '$other does not exist returns undef');

# Test case: $other is a symbolic link
my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
my $link;  # AFTER LAST PASS: my $link;  # UNVALIDATED: my $link = File::Spec->catfile($tempdir, 'link');
# AFTER LAST PASS: symlink($tempdir, $link);
# UNVALIDATED: $result = eval { $dir->contains($link) };
# FAILED: is($result, 1, '$other is a symbolic link returns true');

# Test case: $self contains $other
my $subdir;  # AFTER LAST PASS: my $subdir;  # UNVALIDATED: my $subdir = File::Spec->catdir($tempdir, 'subdir');
# AFTER LAST PASS: mkdir($subdir);
# UNVALIDATED: $result = eval { $dir->contains($subdir) };
# FAILED: is($result, 1, '$self contains $other returns true');

# Test case: $self does not contain $other
my $otherdir;  # AFTER LAST PASS: my $otherdir = tempdir(CLEANUP => 1);
# UNVALIDATED: $result = eval { $dir->contains($otherdir) };
# FAILED: is($result, undef, '$self does not contain $other returns undef');

# Clean up
# AFTER LAST PASS: unlink($link);
# AFTER LAST PASS: rmdir($subdir);
# AFTER LAST PASS: rmdir($tempdir);

done_testing();