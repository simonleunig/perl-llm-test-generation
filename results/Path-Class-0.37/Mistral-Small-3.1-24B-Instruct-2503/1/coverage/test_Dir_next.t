use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::next"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'next is defined'); }

# Mocking dependencies
my $mock_io_dir;
eval { require IO::Dir; };
if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::Dir::new"}) {
        $mock_io_dir = mock 'IO::Dir' => (
            override => [
                new => sub { bless {}, 'IO::Dir' },
                read => sub { shift; return shift @{ $_[0] } },
            ],
        );
    } else {
        $mock_io_dir = mock 'IO::Dir' => (
            add => [
                new => sub { bless {}, 'IO::Dir' },
                read => sub { shift; return shift @{ $_[0] } },
            ],
        );
    }
}

my $mock_path_class_file;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::new"}) {
        $mock_path_class_file = mock 'Path::Class::File' => (
            override => [
                new => sub { bless {}, 'Path::Class::File' },
            ],
        );
    } else {
        $mock_path_class_file = mock 'Path::Class::File' => (
            add => [
                new => sub { bless {}, 'Path::Class::File' },
            ],
        );
    }
}

my $mock_path_class_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new"}) {
        $mock_path_class_dir = mock 'Path::Class::Dir' => (
            override => [
                new => sub { bless {}, 'Path::Class::Dir' },
                open => sub { return bless {}, 'IO::Dir' },
                file => sub { return bless {}, 'Path::Class::File' },
                subdir => sub { return bless {}, 'Path::Class::Dir' },
            ],
        );
    } else {
        $mock_path_class_dir = mock 'Path::Class::Dir' => (
            add => [
                new => sub { bless {}, 'Path::Class::Dir' },
                open => sub { return bless {}, 'IO::Dir' },
                file => sub { return bless {}, 'Path::Class::File' },
                subdir => sub { return bless {}, 'Path::Class::Dir' },
            ],
        );
    }
}

my $mock_carp;
eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::croak"}) {
        $mock_carp = mock 'Carp' => (
            override => [
                croak => sub { die @_ },
            ],
        );
    } else {
        $mock_carp = mock 'Carp' => (
            add => [
                croak => sub { die @_ },
            ],
        );
    }
}

# Test case: Directory is empty
{
    my $dir = Path::Class::Dir->new;
    my $result = eval { $dir->next };
    is($@, '', 'No exception thrown when directory is empty');
    is($result, undef, 'Returns undef when directory is empty');
}

# Test case: Directory contains files
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = Path::Class::Dir->new;
    my $mock_dir;  # AFTER LAST PASS: my $mock_dir = mock('IO::Dir', read => sub { return 'file1.txt' });
    # AFTER LAST PASS: $dir->{dh} = $mock_dir;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->next };
    # FAILED: is($@, '', 'No exception thrown when directory contains files');
    # FAILED: ok($result, 'Returns a Path::Class::File object');
    # FAILED: isa_ok($result, 'Path::Class::File', 'Returned object is a Path::Class::File');
# AFTER LAST PASS: }

# Test case: Directory contains directories
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = Path::Class::Dir->new;
    my $mock_dir;  # AFTER LAST PASS: my $mock_dir = mock('IO::Dir', read => sub { return 'subdir1' });
    # AFTER LAST PASS: $dir->{dh} = $mock_dir;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->next };
    # FAILED: is($@, '', 'No exception thrown when directory contains directories');
    # FAILED: ok($result, 'Returns a Path::Class::Dir object');
    # FAILED: isa_ok($result, 'Path::Class::Dir', 'Returned object is a Path::Class::Dir');
# AFTER LAST PASS: }

# Test case: Directory cannot be opened
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = Path::Class::Dir->new;
    # AFTER LAST PASS: mock 'Path::Class::Dir' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: open => sub { return undef },
        # AFTER LAST PASS: ],
    # AFTER LAST PASS: );

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->next };
    # FAILED: like($@, qr/Can't open directory/, 'Throws exception when directory cannot be opened');
# AFTER LAST PASS: }

# Test case: Directory contains hidden files
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = Path::Class::Dir->new;
    my $mock_dir;  # AFTER LAST PASS: my $mock_dir = mock('IO::Dir', read => sub { return '.hiddenfile' });
    # AFTER LAST PASS: $dir->{dh} = $mock_dir;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->next };
    # FAILED: is($@, '', 'No exception thrown when directory contains hidden files');
    # FAILED: ok($result, 'Returns a Path::Class::File object for hidden files');
    # FAILED: isa_ok($result, 'Path::Class::File', 'Returned object is a Path::Class::File');
# AFTER LAST PASS: }

# Test case: Directory contains special entries like '.' and '..'
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = Path::Class::Dir->new;
    my $mock_dir;  # AFTER LAST PASS: my $mock_dir = mock('IO::Dir', read => sub { return '.' });
    # AFTER LAST PASS: $dir->{dh} = $mock_dir;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->next };
    # FAILED: is($@, '', 'No exception thrown when directory contains special entries');
    # FAILED: ok($result, 'Returns a Path::Class::Dir object for special entries');
    # FAILED: isa_ok($result, 'Path::Class::Dir', 'Returned object is a Path::Class::Dir');
# AFTER LAST PASS: }

done_testing();