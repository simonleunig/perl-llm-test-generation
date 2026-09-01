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
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock = mock 'Path::Class::Entity' => (
            override => [
                new => sub { return bless { path => shift }, 'Path::Class::Dir' },
                resolve => sub { return bless { path => shift }, 'Path::Class::Dir' },
                subsumes => sub { return shift->[0] eq shift->[1] },
            ]
        );
    } else {
        $mock = mock 'Path::Class::Entity' => (
            add => [
                new => sub { return bless { path => shift }, 'Path::Class::Dir' },
                resolve => sub { return bless { path => shift }, 'Path::Class::Dir' },
                subsumes => sub { return shift->[0] eq shift->[1] },
            ]
        );
    }
}

eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::new"}) {
        $mock = mock 'Path::Class::File' => (
            override => [
                new => sub { return bless { path => shift }, 'Path::Class::File' },
                resolve => sub { return bless { path => shift }, 'Path::Class::File' },
            ]
        );
    } else {
        $mock = mock 'Path::Class::File' => (
            add => [
                new => sub { return bless { path => shift }, 'Path::Class::File' },
                resolve => sub { return bless { path => shift }, 'Path::Class::File' },
            ]
        );
    }
}

mock 'Carp' => (
    croak => sub { die shift },
);

# Test cases with eval protection

# Test with valid inputs
my $dir = Path::Class::Dir->new('/valid/dir');
my $file = Path::Class::File->new('/valid/dir/file');
my $result = eval { $dir->contains($file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'contains returns true for valid inputs'); }

# Test with invalid inputs (too many arguments)
$result = eval { $dir->contains($file, 'extra') };
if ($@ !~ /Too many arguments given to contains/) { fail('Function did not throw expected error: ' . $@); } else { pass('Function throws error for too many arguments'); }

# Test with undefined $other
$result = eval { $dir->contains(undef) };
if ($@ !~ /No second entity given to contains/) { fail('Function did not throw expected error: ' . $@); } else { pass('Function throws error for undefined $other'); }

# Test with $self not being a directory
$result = eval { $file->contains($file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'contains returns false for $self not being a directory'); }

# Test with $other not existing
my $non_existent_file = Path::Class::File->new('/non/existent/file');
$result = eval { $dir->contains($non_existent_file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'contains returns false for $other not existing'); }

# Test with $other being a symbolic link
my $tempdir = tempdir(CLEANUP => 1);
my $symlink = File::Spec->catfile($tempdir, 'symlink');
symlink($file->path, $symlink);
my $symlink_file = Path::Class::File->new($symlink);
$result = eval { $dir->contains($symlink_file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'contains returns true for $other being a symbolic link'); }

# Clean up temporary directory
rmdir($tempdir);

done_testing();