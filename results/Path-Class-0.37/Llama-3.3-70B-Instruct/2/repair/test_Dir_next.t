use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::next"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'next is defined'); }

my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result, 'next returns result'); }

my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock_dir = mock 'Path::Class::Dir' => ( override => [ open => sub { return undef } ] );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => ( add => [ open => sub { return undef } ] );
    }
}
$result = eval { $mock_dir->next() };
if ($@) { like($@, qr/Can't open directory/, 'next throws exception when directory cannot be opened'); } else { fail('next did not throw exception'); }

my $mock_dh;
eval { require IO::Dir; };
if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::Dir::read"}) {
        $mock_dh = mock 'IO::Dir' => ( override => [ read => sub { return undef } ] );
    } else {
        $mock_dh = mock 'IO::Dir' => ( add => [ read => sub { return undef } ] );
    }
}
my $mock_dir_with_dh;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock_dir_with_dh = mock 'Path::Class::Dir' => ( override => [ open => sub { return $mock_dh } ] );
    } else {
        $mock_dir_with_dh = mock 'Path::Class::Dir' => ( add => [ open => sub { return $mock_dh } ] );
    }
}
$result = eval { $mock_dir_with_dh->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(!defined $result, 'next returns undef when end of directory is reached'); }

my $mock_file;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::new"}) {
        $mock_file = mock 'Path::Class::File' => ( override => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    } else {
        $mock_file = mock 'Path::Class::File' => ( add => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    }
}
my $mock_dir_with_file;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock_dir_with_file = mock 'Path::Class::Dir' => ( override => [ open => sub { return $mock_dh }, file => sub { return $mock_file } ] );
    } else {
        $mock_dir_with_file = mock 'Path::Class::Dir' => ( add => [ open => sub { return $mock_dh }, file => sub { return $mock_file } ] );
    }
}
$result = eval { $mock_dir_with_file->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result && ref($result) eq 'Path::Class::File', 'next returns file object when entry is a file'); }

my $mock_subdir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new"}) {
        $mock_subdir = mock 'Path::Class::Dir' => ( override => [ new => sub { return bless {}, 'Path::Class::Dir' } ] );
    } else {
        $mock_subdir = mock 'Path::Class::Dir' => ( add => [ new => sub { return bless {}, 'Path::Class::Dir' } ] );
    }
}
my $mock_dir_with_subdir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock_dir_with_subdir = mock 'Path::Class::Dir' => ( override => [ open => sub { return $mock_dh }, subdir => sub { return $mock_subdir } ] );
    } else {
        $mock_dir_with_subdir = mock 'Path::Class::Dir' => ( add => [ open => sub { return $mock_dh }, subdir => sub { return $mock_subdir } ] );
    }
}
$result = eval { $mock_dir_with_subdir->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result && ref($result) eq 'Path::Class::Dir', 'next returns dir object when entry is a directory'); }

done_testing();