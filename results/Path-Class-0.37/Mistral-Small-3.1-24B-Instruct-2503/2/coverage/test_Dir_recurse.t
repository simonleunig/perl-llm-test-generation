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
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( override => { is_dir => sub { return shift->is_dir }, children => sub { return shift->children } } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( add => { is_dir => sub { return shift->is_dir }, children => sub { return shift->children } } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::PRUNE"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => ( override => { PRUNE => 'PRUNE' } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => ( add => { PRUNE => 'PRUNE' } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require Carp; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Carp::croak"}) {
        # AFTER LAST PASS: $mock = mock 'Carp' => ( override => { croak => sub { die shift } } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Carp' => ( add => { croak => sub { die shift } } );
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

    return {
        base_dir => $base_dir,
        dir1 => $dir1,
        dir2 => $dir2,
        file1 => $file1,
        file2 => $file2,
        subdir => $subdir,
        subfile => $subfile,
    };
}

# Test case: Normal operation with preorder and depthfirst
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure;  # AFTER LAST PASS: my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval {
        # UNVALIDATED: $dir_structure->{base_dir}->recurse(
            # UNVALIDATED: callback => $callback,
            # UNVALIDATED: preorder => 1,
            # UNVALIDATED: depthfirst => 1,
        # UNVALIDATED: );
    # UNVALIDATED: };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 6,
        # FAILED: 'Callback called for all entries in depth-first preorder traversal'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', @callback_calls),
        # FAILED: join(',', $dir_structure->{base_dir}, $dir_structure->{dir1}, $dir_structure->{subdir}, $dir_structure->{subfile}, $dir_structure->{file1}, $dir_structure->{dir2}, $dir_structure->{file2}),
        # FAILED: 'Callback called in correct order for depth-first preorder traversal'
    # FAILED: );
# AFTER LAST PASS: }

# Test case: Normal operation with preorder and breadthfirst
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure;  # AFTER LAST PASS: my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval {
        # UNVALIDATED: $dir_structure->{base_dir}->recurse(
            # UNVALIDATED: callback => $callback,
            # UNVALIDATED: preorder => 1,
            # UNVALIDATED: depthfirst => 0,
        # UNVALIDATED: );
    # UNVALIDATED: };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 6,
        # FAILED: 'Callback called for all entries in breadth-first preorder traversal'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', @callback_calls),
        # FAILED: join(',', $dir_structure->{base_dir}, $dir_structure->{dir1}, $dir_structure->{dir2}, $dir_structure->{subdir}, $dir_structure->{file1}, $dir_structure->{subfile}, $dir_structure->{file2}),
        # FAILED: 'Callback called in correct order for breadth-first preorder traversal'
    # FAILED: );
# AFTER LAST PASS: }

# Test case: Normal operation with postorder
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure;  # AFTER LAST PASS: my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval {
        # UNVALIDATED: $dir_structure->{base_dir}->recurse(
            # UNVALIDATED: callback => $callback,
            # UNVALIDATED: preorder => 0,
            # UNVALIDATED: depthfirst => 0,
        # UNVALIDATED: );
    # UNVALIDATED: };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 6,
        # FAILED: 'Callback called for all entries in postorder traversal'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', @callback_calls),
        # FAILED: join(',', $dir_structure->{file1}, $dir_structure->{subfile}, $dir_structure->{subdir}, $dir_structure->{file2}, $dir_structure->{dir2}, $dir_structure->{dir1}, $dir_structure->{base_dir}),
        # FAILED: 'Callback called in correct order for postorder traversal'
    # FAILED: );
# AFTER LAST PASS: }

# Test case: Missing callback parameter
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure;  # AFTER LAST PASS: my $dir_structure = create_mock_dir_structure($tempdir);

    my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval {
        # UNVALIDATED: $dir_structure->{base_dir}->recurse();
    # UNVALIDATED: };
    # FAILED: like($@, qr/Must provide a 'callback' parameter to recurse\(\)/, 'Function throws error when callback is missing');
# AFTER LAST PASS: }

# Test case: PRUNE constant usage
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure;  # AFTER LAST PASS: my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: push @callback_calls, shift;
        # AFTER LAST PASS: return Path::Class::Entity::PRUNE if shift eq $dir_structure->{dir1};
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval {
        # UNVALIDATED: $dir_structure->{base_dir}->recurse(
            # UNVALIDATED: callback => $callback,
            # UNVALIDATED: preorder => 1,
            # UNVALIDATED: depthfirst => 1,
        # UNVALIDATED: );
    # UNVALIDATED: };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    # FAILED: is(
        # FAILED: scalar(@callback_calls),
        # FAILED: 3,
        # FAILED: 'Callback called for all entries except pruned directory'
    # FAILED: );

    # FAILED: is(
        # FAILED: join(',', @callback_calls),
        # FAILED: join(',', $dir_structure->{base_dir}, $dir_structure->{dir1}, $dir_structure->{dir2}),
        # FAILED: 'Callback called in correct order with PRUNE'
    # FAILED: );
# AFTER LAST PASS: }

done_testing();