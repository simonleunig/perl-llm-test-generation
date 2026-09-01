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
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::is_dir"}) {
        $mock = mock 'Path::Class::File' => ( override => { is_dir => sub { return shift->is_dir }, children => sub { return shift->children } } );
    } else {
        $mock = mock 'Path::Class::File' => ( add => { is_dir => sub { return shift->is_dir }, children => sub { return shift->children } } );
    }
}

eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::PRUNE"}) {
        $mock = mock 'Path::Class::Entity' => ( override => { PRUNE => 'PRUNE' } );
    } else {
        $mock = mock 'Path::Class::Entity' => ( add => { PRUNE => 'PRUNE' } );
    }
}

eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::croak"}) {
        $mock = mock 'Carp' => ( override => { croak => sub { die shift } } );
    } else {
        $mock = mock 'Carp' => ( add => { croak => sub { die shift } } );
    }
}

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
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback = sub {
        push @callback_calls, shift;
    };

    my $result = eval {
        $dir_structure->{base_dir}->recurse(
            callback => $callback,
            preorder => 1,
            depthfirst => 1,
        );
    };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    is(
        scalar(@callback_calls),
        6,
        'Callback called for all entries in depth-first preorder traversal'
    );

    is(
        join(',', @callback_calls),
        join(',', $dir_structure->{base_dir}, $dir_structure->{dir1}, $dir_structure->{subdir}, $dir_structure->{subfile}, $dir_structure->{file1}, $dir_structure->{dir2}, $dir_structure->{file2}),
        'Callback called in correct order for depth-first preorder traversal'
    );
}

# Test case: Normal operation with preorder and breadthfirst
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback = sub {
        push @callback_calls, shift;
    };

    my $result = eval {
        $dir_structure->{base_dir}->recurse(
            callback => $callback,
            preorder => 1,
            depthfirst => 0,
        );
    };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    is(
        scalar(@callback_calls),
        6,
        'Callback called for all entries in breadth-first preorder traversal'
    );

    is(
        join(',', @callback_calls),
        join(',', $dir_structure->{base_dir}, $dir_structure->{dir1}, $dir_structure->{dir2}, $dir_structure->{subdir}, $dir_structure->{file1}, $dir_structure->{subfile}, $dir_structure->{file2}),
        'Callback called in correct order for breadth-first preorder traversal'
    );
}

# Test case: Normal operation with postorder
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback = sub {
        push @callback_calls, shift;
    };

    my $result = eval {
        $dir_structure->{base_dir}->recurse(
            callback => $callback,
            preorder => 0,
            depthfirst => 0,
        );
    };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    is(
        scalar(@callback_calls),
        6,
        'Callback called for all entries in postorder traversal'
    );

    is(
        join(',', @callback_calls),
        join(',', $dir_structure->{file1}, $dir_structure->{subfile}, $dir_structure->{subdir}, $dir_structure->{file2}, $dir_structure->{dir2}, $dir_structure->{dir1}, $dir_structure->{base_dir}),
        'Callback called in correct order for postorder traversal'
    );
}

# Test case: Missing callback parameter
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure = create_mock_dir_structure($tempdir);

    my $error = eval {
        $dir_structure->{base_dir}->recurse();
    };
    like($@, qr/Must provide a 'callback' parameter to recurse\(\)/, 'Function throws error when callback is missing');
}

# Test case: PRUNE constant usage
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $dir_structure = create_mock_dir_structure($tempdir);

    my @callback_calls;
    my $callback = sub {
        push @callback_calls, shift;
        return Path::Class::Entity::PRUNE if shift eq $dir_structure->{dir1};
    };

    my $result = eval {
        $dir_structure->{base_dir}->recurse(
            callback => $callback,
            preorder => 1,
            depthfirst => 1,
        );
    };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function executed without crashing'); }

    is(
        scalar(@callback_calls),
        3,
        'Callback called for all entries except pruned directory'
    );

    is(
        join(',', @callback_calls),
        join(',', $dir_structure->{base_dir}, $dir_structure->{dir1}, $dir_structure->{dir2}),
        'Callback called in correct order with PRUNE'
    );
}

done_testing();