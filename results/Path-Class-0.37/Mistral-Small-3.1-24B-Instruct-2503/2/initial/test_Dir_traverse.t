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
mock 'Path::Class::Dir' => (
    override => [
        children => sub {
            my $self = shift;
            return @_;
        },
    ],
);

# Test case: Empty directory
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 1; };
    my $result = eval { $dir->traverse($callback) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty directory'); }
    is($result, 1, 'Callback called once for empty directory');
}

# Test case: Non-existent directory
{
    my $dir = bless {}, 'Path::Class::Dir';
    mock 'Path::Class::Dir' => (
        override => [
            children => sub {
                Carp::croak('Directory does not exist');
            },
        ],
    );
    my $callback = sub { return 1; };
    my $result = eval { $dir->traverse($callback) };
    if ($@) { ok(1, 'Function croaks for non-existent directory'); } else { fail('Function did not croak for non-existent directory'); }
}

# Test case: Inaccessible directory
{
    my $dir = bless {}, 'Path::Class::Dir';
    mock 'Path::Class::Dir' => (
        override => [
            children => sub {
                Carp::croak('Directory is inaccessible');
            },
        ],
    );
    my $callback = sub { return 1; };
    my $result = eval { $dir->traverse($callback) };
    if ($@) { ok(1, 'Function croaks for inaccessible directory'); } else { fail('Function did not croak for inaccessible directory'); }
}

# Test case: Normal directory traversal
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $dir = bless { path => $tempdir }, 'Path::Class::Dir';
    my $subdir = File::Spec->catdir($tempdir, 'subdir');
    mkdir $subdir;
    my $file = File::Spec->catfile($subdir, 'file.txt');
    open(my $fh, '>', $file) or die "Could not create file '$file' $!";
    close($fh);

    my $callback = sub {
        my ($item, @args) = @_;
        return $item->path;
    };

    my $result = eval { $dir->traverse($callback) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for normal directory traversal'); }
    is($result, $tempdir, 'Callback returns correct path for root directory');
}

# Test case: Callback returns PRUNE
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub {
        return 'PRUNE';
    };
    my $result = eval { $dir->traverse($callback) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for PRUNE callback'); }
    is($result, 'PRUNE', 'Callback returns PRUNE');
}

done_testing();
