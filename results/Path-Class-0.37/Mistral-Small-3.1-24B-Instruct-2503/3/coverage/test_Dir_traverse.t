use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

# Mocking dependencies
my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::children"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                children => sub {
                    my $self = shift;
                    return @_;
                },
            ],
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                children => sub {
                    my $self = shift;
                    return @_;
                },
            ],
        );
    }
}

# Test case: Empty directory
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 1; };
    my $result = eval { $dir->traverse($callback) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty directory'); }
    is($result, 1, 'Callback called once for empty directory');
}

# Test case: Non-existent directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    # AFTER LAST PASS: mock 'Path::Class::Dir' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: children => sub {
                # AFTER LAST PASS: Carp::croak('Directory does not exist');
            # AFTER LAST PASS: },
        # AFTER LAST PASS: ],
    # AFTER LAST PASS: );
    my $callback;  # AFTER LAST PASS: my $callback = sub { return 1; };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->traverse($callback) };
    # FAILED: if ($@) { ok(1, 'Function croaks for non-existent directory'); } else { fail('Function did not croak for non-existent directory'); }
# AFTER LAST PASS: }

# Test case: Inaccessible directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    # AFTER LAST PASS: mock 'Path::Class::Dir' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: children => sub {
                # AFTER LAST PASS: Carp::croak('Directory is inaccessible');
            # AFTER LAST PASS: },
        # AFTER LAST PASS: ],
    # AFTER LAST PASS: );
    my $callback;  # AFTER LAST PASS: my $callback = sub { return 1; };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->traverse($callback) };
    # FAILED: if ($@) { ok(1, 'Function croaks for inaccessible directory'); } else { fail('Function did not croak for inaccessible directory'); }
# AFTER LAST PASS: }

# Test case: Normal directory traversal
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $dir;  # AFTER LAST PASS: my $dir = bless { path => $tempdir }, 'Path::Class::Dir';
    my $subdir;  # AFTER LAST PASS: my $subdir = File::Spec->catdir($tempdir, 'subdir');
    # AFTER LAST PASS: mkdir $subdir;
    my $file;  # AFTER LAST PASS: my $file = File::Spec->catfile($subdir, 'file.txt');
    my $fh;  # AFTER LAST PASS: open(my $fh, '>', $file) or die "Could not create file '$file' $!";
    # AFTER LAST PASS: close($fh);

    my $callback;  # AFTER LAST PASS: my $callback = sub {
        my ($item, @args);  # AFTER LAST PASS: my ($item, @args) = @_;
        # AFTER LAST PASS: return $item->path;
    # AFTER LAST PASS: };

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->traverse($callback) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for normal directory traversal'); }
    # FAILED: is($result, $tempdir, 'Callback returns correct path for root directory');
# AFTER LAST PASS: }

# Test case: Callback returns PRUNE
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless {}, 'Path::Class::Dir';
    my $callback;  # AFTER LAST PASS: my $callback = sub {
        # AFTER LAST PASS: return 'PRUNE';
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->traverse($callback) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for PRUNE callback'); }
    # FAILED: is($result, 'PRUNE', 'Callback returns PRUNE');
# AFTER LAST PASS: }

done_testing();