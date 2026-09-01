use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Test case: dir is defined
my $file = Path::Class::File->new('test.txt');
my $dir = $file->{dir} = Path::Class::Dir->new('test_dir');
my $result = eval { $file->dir() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $dir, 'dir returns defined directory'); }

# Test case: dir is not defined
my $file2 = Path::Class::File->new('test2.txt');
my $result2 = eval { $file2->dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, 'dir returns new directory when not defined'); }

# Test case: dir creation with _spec
my $mock_spec = mock 'Path::Class::File' => (
    _spec => mock '_spec' => (
        curdir => '/mock_curdir',
    ),
);
my $file3 = Path::Class::File->new('test3.txt');
my $result3 = eval { $file3->dir() };
if ($@) { fail('Function crashed: ' . $@); } else { like($result3->stringify, qr{/mock_curdir$}, 'dir creates new directory with _spec'); }

done_testing();
