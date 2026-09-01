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

# Mocking dependencies
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

mock 'Carp' => (
    override => [
        croak => sub { die @_ },
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
    my $mock_dir = mock('IO::Dir', read => sub { return 'file1.txt' });
    $dir->{dh} = $mock_dir;

    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory contains files');
    ok($result, 'Returns a Path::Class::File object');
    isa_ok($result, 'Path::Class::File', 'Returned object is a Path::Class::File');
}

# Test case: Directory contains directories
{
    my $dir = Path::Class::Dir->new;
    my $mock_dir = mock('IO::Dir', read => sub { return 'subdir1' });
    $dir->{dh} = $mock_dir;

    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory contains directories');
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
}

# Test case: Directory contains hidden files
{
    my $dir = Path::Class::Dir->new;
    my $mock_dir = mock('IO::Dir', read => sub { return '.hiddenfile' });
    $dir->{dh} = $mock_dir;

    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory contains hidden files');
    ok($result, 'Returns a Path::Class::File object for hidden files');
    isa_ok($result, 'Path::Class::File', 'Returned object is a Path::Class::File');
}

# Test case: Directory contains special entries like '.' and '..'
{
    my $dir = Path::Class::Dir->new;
    my $mock_dir = mock('IO::Dir', read => sub { return '.' });
    $dir->{dh} = $mock_dir;

    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory contains special entries');
    ok($result, 'Returns a Path::Class::Dir object for special entries');
    isa_ok($result, 'Path::Class::Dir', 'Returned object is a Path::Class::Dir');
}

done_testing();
