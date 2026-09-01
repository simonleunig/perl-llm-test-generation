use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use Scalar::Util qw(looks_like_number);
use Storable qw(dclone);
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memcopy"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memcopy is defined'); }

# Mocking dependencies
my $mock;
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Storable::dclone"}) {
        $mock = mock 'Storable' => ( override => [ dclone => sub { my $data = shift; return dclone($data); } ] );
    } else {
        $mock = mock 'Storable' => ( add => [ dclone => sub { my $data = shift; return dclone($data); } ] );
    }
}

eval { require File::Basename; };
if ($@) {
    # DEPENDENCY MISSING: File::Basename - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Basename::fileparse"}) {
        $mock = mock 'File::Basename' => ( override => [ fileparse => sub { return ('', shift); } ] );
    } else {
        $mock = mock 'File::Basename' => ( add => [ fileparse => sub { return ('', shift); } ] );
    }
}

eval { require File::Spec; };
if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Spec::catfile"}) {
        $mock = mock 'File::Spec' => ( override => [ catfile => sub { return shift; } ] );
    } else {
        $mock = mock 'File::Spec' => ( add => [ catfile => sub { return shift; } ] );
    }
    if (defined &{"File::Spec::catdir"}) {
        $mock = mock 'File::Spec' => ( override => [ catdir => sub { return shift; } ] );
    } else {
        $mock = mock 'File::Spec' => ( add => [ catdir => sub { return shift; } ] );
    }
    if (defined &{"File::Spec::tmpdir"}) {
        $mock = mock 'File::Spec' => ( override => [ tmpdir => sub { return '/tmp'; } ] );
    } else {
        $mock = mock 'File::Spec' => ( add => [ tmpdir => sub { return '/tmp'; } ] );
    }
}

# Mocking MemCopyCache
our %MemCopyCache;

# Test case 1: Cache exists and is valid
{
    my ($fh, $filename) = tempfile();
    my $data = { key => 'value' };
    $MemCopyCache{$filename} = [ time(), $data ];
    my $result = eval { XML::Simple::cache_read_memcopy(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $data, 'Cache exists and is valid');
    }
}

# Test case 2: Cache does not exist
{
    my ($fh, $filename) = tempfile();
    my $result = eval { XML::Simple::cache_read_memcopy(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Cache does not exist');
    }
}

# Test case 3: Cache is outdated
{
    my ($fh, $filename) = tempfile();
    my $data = { key => 'value' };
    $MemCopyCache{$filename} = [ time() - 3600, $data ];
    my $result = eval { XML::Simple::cache_read_memcopy(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Cache is outdated');
    }
}

# Test case 4: File modification time is newer than cache time
{
    my ($fh, $filename) = tempfile();
    my $data = { key => 'value' };
    $MemCopyCache{$filename} = [ time() - 3600, $data ];
    utime time(), time(), $filename;
    my $result = eval { XML::Simple::cache_read_memcopy(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'File modification time is newer than cache time');
    }
}

done_testing();