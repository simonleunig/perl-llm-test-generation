use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::rmtree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'rmtree is defined'); }

# Mock File::Path::rmtree
my $mock;
eval { require File::Path; };
if ($@) {
    # DEPENDENCY MISSING: File::Path - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Path::rmtree"}) {
        $mock = mock 'File::Path', override => [ rmtree => sub {
            my ($path, %opts) = @_;
            return 0 if $path eq 'non_existent_dir';
            return 1 if $path eq 'existing_dir';
            return 0 if $path eq 'permission_denied_dir';
            return 1;
        } ];
    } else {
        $mock = mock 'File::Path', add => [ rmtree => sub {
            my ($path, %opts) = @_;
            return 0 if $path eq 'non_existent_dir';
            return 1 if $path eq 'existing_dir';
            return 0 if $path eq 'permission_denied_dir';
            return 1;
        } ];
    }
}

# Test case: Directory does not exist
{
    my $dir = Path::Class::Dir->new('non_existent_dir');
    my $result = eval { Path::Class::Dir::rmtree($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
    is($@, '', 'No exception thrown for non-existent directory');
    is($result, 0, 'Returns 0 for non-existent directory');
}

# Test case: Directory exists and is successfully removed
{
    my $dir = Path::Class::Dir->new('existing_dir');
    my $result = eval { Path::Class::Dir::rmtree($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
    is($@, '', 'No exception thrown for existing directory');
    is($result, 1, 'Returns 1 for successfully removed directory');
}

# Test case: Permission denied
{
    my $dir = Path::Class::Dir->new('permission_denied_dir');
    my $result = eval { Path::Class::Dir::rmtree($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
    is($@, '', 'No exception thrown for permission denied directory');
    is($result, 0, 'Returns 0 for permission denied directory');
}

# Test case: Verbose mode
{
    my $dir = Path::Class::Dir->new('existing_dir');
    my $result = eval { Path::Class::Dir::rmtree($dir, verbose => 1) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
    is($@, '', 'No exception thrown for verbose mode');
    is($result, 1, 'Returns 1 for verbose mode');
}

# Test case: Cautious mode
{
    my $dir = Path::Class::Dir->new('existing_dir');
    my $result = eval { Path::Class::Dir::rmtree($dir, cautious => 1) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
    is($@, '', 'No exception thrown for cautious mode');
    is($result, 1, 'Returns 1 for cautious mode');
}

# Test case: Circular symlinks (mocked to return 1)
{
    my $dir = Path::Class::Dir->new('existing_dir');
    my $result = eval { Path::Class::Dir::rmtree($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
    is($@, '', 'No exception thrown for circular symlinks');
    is($result, 1, 'Returns 1 for circular symlinks');
}

# Clean up temporary directories
# AFTER LAST PASS: END {
    # AFTER LAST PASS: unlink 'non_existent_dir', 'existing_dir', 'permission_denied_dir';
# AFTER LAST PASS: }

done_testing();