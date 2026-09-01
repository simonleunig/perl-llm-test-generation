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
mock 'Path::Class::File' => ( new => sub { return bless {}, 'Path::Class::File' } );
mock 'Path::Class::Entity' => ( new => sub { return bless {}, 'Path::Class::Entity' } );
mock 'IO::Dir' => ();
mock 'File::Path' => ();
mock 'File::Temp' => ();
mock 'Scalar::Util' => ();

# Test case: Too many arguments
my $result = eval { Path::Class::Dir::contains('arg1', 'arg2', 'arg3') };
is($@, 'Too many arguments given to contains()', 'Too many arguments throws exception');

# Test case: No second entity given
$result = eval { Path::Class::Dir::contains('arg1') };
is($@, 'No second entity given to contains()', 'No second entity throws exception');

# Test case: $self is not a directory
my $dir = bless {}, 'Path::Class::Dir';
mock $dir => ( new => sub { return $dir }, resolve => sub { return $dir }, subsumes => sub { return 1 } );
$result = eval { $dir->contains('arg2') };
is($result, undef, '$self is not a directory returns undef');

# Test case: $other does not exist
mock $dir => ( new => sub { return $dir }, resolve => sub { return $dir }, subsumes => sub { return 1 } );
$result = eval { $dir->contains('nonexistent') };
is($result, undef, '$other does not exist returns undef');

# Test case: $other is a symbolic link
my $tempdir = tempdir(CLEANUP => 1);
my $link = File::Spec->catfile($tempdir, 'link');
symlink($tempdir, $link);
$result = eval { $dir->contains($link) };
is($result, 1, '$other is a symbolic link returns true');

# Test case: $self contains $other
my $subdir = File::Spec->catdir($tempdir, 'subdir');
mkdir($subdir);
$result = eval { $dir->contains($subdir) };
is($result, 1, '$self contains $other returns true');

# Test case: $self does not contain $other
my $otherdir = tempdir(CLEANUP => 1);
$result = eval { $dir->contains($otherdir) };
is($result, undef, '$self does not contain $other returns undef');

# Clean up
unlink($link);
rmdir($subdir);
rmdir($tempdir);

done_testing();
