use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::next"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'next is defined'); }

# Mock dependencies
mock 'IO::Dir' => (
    override => [
        new => sub { bless {}, 'IO::Dir' },
        read => sub { shift; return shift @{ $_[0] } },
    ],
);

mock 'Path::Class::File' => (
    override => [
        new => sub { bless {}, 'Path::Class::File' },
    ],
);

mock 'Path::Class::Dir' => (
    override => [
        new => sub { bless {}, 'Path::Class::Dir' },
        open => sub { return bless {}, 'IO::Dir' },
        file => sub { return bless {}, 'Path::Class::File' },
        subdir => sub { return bless {}, 'Path::Class::Dir' },
    ],
);

# Test case: Directory is empty
{
    my $dir = Path::Class::Dir->new;
    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory is empty');
    is($result, undef, 'Returns undef when directory is empty');
}

# Test case: Directory contains files
{
    my $dir = Path::Class::Dir->new;
    my $tempdir = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($tempdir, 'testfile.txt');
    open(my $fh, '>', $file) or die "Cannot create file: $!";
    close($fh);

    mock 'IO::Dir' => (
        override => [
            read => sub { return 'testfile.txt' },
        ],
    );

    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory contains files');
    ok($result, 'Returns a Path::Class::File object');
    isa_ok($result, 'Path::Class::File', 'Returned object is a Path::Class::File');
}

# Test case: Directory contains subdirectories
{
    my $dir = Path::Class::Dir->new;
    my $tempdir = tempdir(CLEANUP => 1);
    my $subdir = File::Spec->catdir($tempdir, 'subdir');
    mkdir($subdir) or die "Cannot create directory: $!";

    mock 'IO::Dir' => (
        override => [
            read => sub { return 'subdir' },
        ],
    );

    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory contains subdirectories');
    ok($result, 'Returns a Path::Class::Dir object');
    isa_ok($result, 'Path::Class::Dir', 'Returned object is a Path::Class::Dir');
}

# Test case: Directory cannot be opened
{
    my $dir = Path::Class::Dir->new;
    mock 'Path::Class::Dir' => (
        override => [
            open => sub { return undef },
        ],
    );

    my $result = eval { $dir->next };
    like($@, qr/Can't open directory/, 'Throws exception when directory cannot be opened');
    is($result, undef, 'Returns undef when directory cannot be opened');
}

done_testing();
