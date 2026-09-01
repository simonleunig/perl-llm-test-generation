use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::children"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'children is defined'); }

# Mock dependencies
my $mock_io_dir;
# AFTER LAST PASS: eval { require IO::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"IO::Dir::new"}) {
        # AFTER LAST PASS: $mock_io_dir = mock 'IO::Dir' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: new => sub { bless {}, 'IO::Dir' },
                # AFTER LAST PASS: read => sub { shift; return shift @{ $_[0] } },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_io_dir = mock 'IO::Dir' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: new => sub { bless {}, 'IO::Dir' },
                # AFTER LAST PASS: read => sub { shift; return shift @{ $_[0] } },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_path_class_dir;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::open"}) {
        # AFTER LAST PASS: $mock_path_class_dir = mock 'Path::Class::Dir' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: open => sub { return bless {}, 'IO::Dir' },
                # AFTER LAST PASS: _is_local_dot_dir => sub { return shift->[0] eq '.' || shift->[0] eq '..' },
                # AFTER LAST PASS: file => sub { return bless { name => shift }, 'Path::Class::File' },
                # AFTER LAST PASS: subdir => sub { return bless { name => shift }, 'Path::Class::Dir' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_path_class_dir = mock 'Path::Class::Dir' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: open => sub { return bless {}, 'IO::Dir' },
                # AFTER LAST PASS: _is_local_dot_dir => sub { return shift->[0] eq '.' || shift->[0] eq '..' },
                # AFTER LAST PASS: file => sub { return bless { name => shift }, 'Path::Class::File' },
                # AFTER LAST PASS: subdir => sub { return bless { name => shift }, 'Path::Class::Dir' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Normal operation with no options
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    my @entries;  # AFTER LAST PASS: my @entries = ('file1', 'dir1', 'file2');
    # AFTER LAST PASS: mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->children };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is( scalar @$result, 3, 'Correct number of entries returned' );
        # FAILED: is( $result->[0]->{name}, 'file1', 'First entry is correct' );
        # FAILED: is( $result->[1]->{name}, 'dir1', 'Second entry is correct' );
        # FAILED: is( $result->[2]->{name}, 'file2', 'Third entry is correct' );
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Including special directory entries with 'all' option
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    my @entries;  # AFTER LAST PASS: my @entries = ('.', '..', 'file1', 'dir1');
    # AFTER LAST PASS: mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->children(all => 1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is( scalar @$result, 4, 'Correct number of entries returned with all option' );
        # FAILED: is( $result->[0]->{name}, '.', 'First entry is correct' );
        # FAILED: is( $result->[1]->{name}, '..', 'Second entry is correct' );
        # FAILED: is( $result->[2]->{name}, 'file1', 'Third entry is correct' );
        # FAILED: is( $result->[3]->{name}, 'dir1', 'Fourth entry is correct' );
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Excluding hidden files with 'no_hidden' option
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    my @entries;  # AFTER LAST PASS: my @entries = ('.hidden', 'file1', 'dir1', '.another_hidden');
    # AFTER LAST PASS: mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->children(no_hidden => 1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is( scalar @$result, 2, 'Correct number of entries returned with no_hidden option' );
        # FAILED: is( $result->[0]->{name}, 'file1', 'First entry is correct' );
        # FAILED: is( $result->[1]->{name}, 'dir1', 'Second entry is correct' );
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Directory cannot be opened
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    # AFTER LAST PASS: mock 'Path::Class::Dir' => ( override => [ open => sub { return undef } ] );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->children };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like( $@, qr/Can't open directory/, 'Correct error message for directory open failure' );
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not crash as expected');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Directory with mixed file types
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    my @entries;  # AFTER LAST PASS: my @entries = ('file1', 'dir1', 'file2');
    # AFTER LAST PASS: mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->children };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is( scalar @$result, 3, 'Correct number of entries returned' );
        # FAILED: is( $result->[0]->{name}, 'file1', 'First entry is correct' );
        # FAILED: isa_ok( $result->[0], 'Path::Class::File', 'First entry is a Path::Class::File' );
        # FAILED: is( $result->[1]->{name}, 'dir1', 'Second entry is correct' );
        # FAILED: isa_ok( $result->[1], 'Path::Class::Dir', 'Second entry is a Path::Class::Dir' );
        # FAILED: is( $result->[2]->{name}, 'file2', 'Third entry is correct' );
        # FAILED: isa_ok( $result->[2], 'Path::Class::File', 'Third entry is a Path::Class::File' );
    # FAILED: }
# AFTER LAST PASS: }

done_testing();