use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::children"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'children is defined'); }

my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->children() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for successful directory opening'); }

my $mock = mock 'Path::Class::Dir' => (
    open => sub { return undef },
);
my $dir2 = Path::Class::Dir->new($temp_dir);
my $result2 = eval { $dir2->children() };
if ($@) { like($@, qr/Can't open directory/, 'Function throws exception for directory opening failure'); } else { fail('Expected function to throw exception'); }

my $mock2 = mock 'Path::Class::Dir' => (
    _is_local_dot_dir => sub { return 1 },
);
my $dir3 = Path::Class::Dir->new($temp_dir);
my $result3 = eval { $dir3->children() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result3, 'Function returns result for current directory'); }

my $mock3 = mock 'Path::Class::Dir' => (
    open => sub { return IO::Dir->new($temp_dir) },
    _is_local_dot_dir => sub { return 0 },
);
my $dir4 = Path::Class::Dir->new($temp_dir);
my $result4 = eval { $dir4->children(no_hidden => 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns result for hidden files'); }

my $error = eval { File::Path::rmdir($temp_dir) };
if ($@) { fail('rmdir crashed: ' . $@); }

done_testing();