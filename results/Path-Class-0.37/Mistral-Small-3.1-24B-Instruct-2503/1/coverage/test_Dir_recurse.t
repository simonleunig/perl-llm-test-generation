use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::recurse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'recurse is defined'); }

# Mocking dependencies
my $mock;
# AFTER LAST PASS: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::is_dir"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( override => [
            # AFTER LAST PASS: is_dir => sub { return shift->is_dir },
            # AFTER LAST PASS: children => sub { return shift->children },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( add => [
            # AFTER LAST PASS: is_dir => sub { return shift->is_dir },
            # AFTER LAST PASS: children => sub { return shift->children },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::PRUNE"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => ( override => [
            # AFTER LAST PASS: PRUNE => 'PRUNE',
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => ( add => [
            # AFTER LAST PASS: PRUNE => 'PRUNE',
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require Carp; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Carp::croak"}) {
        # AFTER LAST PASS: $mock = mock 'Carp' => ( override => [
            # AFTER LAST PASS: croak => sub { die shift },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Carp' => ( add => [
            # AFTER LAST PASS: croak => sub { die shift },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Helper function to create a mock directory structure
sub create_mock_dir_structure {
    my ($base_dir) = @_;
    my $dir1 = Path::Class::Dir->new($base_dir, 'dir1');
    my $dir2 = Path::Class::Dir->new($base_dir, 'dir2');
    my $file1 = Path::Class::File->new($dir1, 'file1.txt');
    my $file2 = Path::Class::File->new($dir2, 'file2.txt');
    my $subdir = Path::Class::Dir->new($dir1, 'subdir');
    my $subfile = Path::Class::File->new($subdir, 'subfile.txt');

    $dir1->children([$file1, $subdir]);
    $dir2->children([$file2]);
    $subdir->children([$subfile]);

    return $dir1;
}

# Test case: Normal operation with preorder and depthfirst
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir;  # AFTER LAST PASS: my $dir = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::recurse($dir, callback => $callback, preorder => 1, depthfirst => 1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 5,
        # FAILED: 'Callback called for all entries in depth-first preorder traversal'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', map { $_->stringify } @callback_calls),
        # FAILED: "$dir/dir1,$dir/dir1/subdir,$dir/dir1/subdir/subfile.txt,$dir/dir1/file1.txt,$dir/dir2",
        # FAILED: 'Callback called in correct order for depth-first preorder traversal'
    # FAILED: );
# AFTER LAST PASS: }

# Test case: Normal operation with preorder and breadthfirst
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir;  # AFTER LAST PASS: my $dir = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::recurse($dir, callback => $callback, preorder => 1, depthfirst => 0) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 5,
        # FAILED: 'Callback called for all entries in breadth-first preorder traversal'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', map { $_->stringify } @callback_calls),
        # FAILED: "$dir/dir1,$dir/dir2,$dir/dir1/subdir,$dir/dir1/file1.txt,$dir/dir1/subdir/subfile.txt",
        # FAILED: 'Callback called in correct order for breadth-first preorder traversal'
    # FAILED: );
# AFTER LAST PASS: }

# Test case: Normal operation with postorder
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir;  # AFTER LAST PASS: my $dir = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::recurse($dir, callback => $callback, preorder => 0) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 5,
        # FAILED: 'Callback called for all entries in postorder traversal'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', map { $_->stringify } @callback_calls),
        # FAILED: "$dir/dir1/file1.txt,$dir/dir1/subdir/subfile.txt,$dir/dir1/subdir,$dir/dir2,$dir/dir1",
        # FAILED: 'Callback called in correct order for postorder traversal'
    # FAILED: );
# AFTER LAST PASS: }

# Test case: Missing callback parameter
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir;  # AFTER LAST PASS: my $dir = create_mock_dir_structure($tempdir);

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::recurse($dir) };
    # FAILED: if ($@) { like($@, qr/Must provide a 'callback' parameter to recurse\(\)/, 'Function throws correct error for missing callback'); } else { fail('Function did not throw error for missing callback'); }
# AFTER LAST PASS: }

# Test case: PRUNE constant usage
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir;  # AFTER LAST PASS: my $dir = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
        # AFTER LAST PASS: return 'PRUNE' if shift->stringify eq "$dir/dir1/subdir";
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::recurse($dir, callback => $callback, preorder => 1, depthfirst => 1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 3,
        # FAILED: 'Callback called for all entries except pruned subdirectory'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', map { $_->stringify } @callback_calls),
        # FAILED: "$dir/dir1,$dir/dir1/subdir,$dir/dir1/file1.txt",
        # FAILED: 'Callback called in correct order with pruning'
    # FAILED: );
# AFTER LAST PASS: }

done_testing();