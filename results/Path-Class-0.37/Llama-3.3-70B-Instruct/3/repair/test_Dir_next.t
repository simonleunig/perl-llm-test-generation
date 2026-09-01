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

my $temp_dir = tempdir(CLEANUP => 1);

my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock = mock 'Path::Class::Dir' => ( override => [ open => sub { return undef } ] );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => [ open => sub { return undef } ] );
    }
}
my $result2 = eval { $mock->next() };
if ($@) { like($@, qr/Can't open directory/, 'Correct error message'); } else { fail('Expected function to crash'); }

my $mock2;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock2 = mock 'Path::Class::Dir' => ( override => [ open => sub { return bless {}, 'IO::Dir' } ] );
    } else {
        $mock2 = mock 'Path::Class::Dir' => ( add => [ open => sub { return bless {}, 'IO::Dir' } ] );
    }
}
$mock2->{dh} = bless {}, 'IO::Dir';
$mock2->{dh}->read = sub { return undef };
my $result3 = eval { $mock2->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'Function returns undef at end of directory'); }

my $file = tempfile(DIR => $temp_dir);
my $result4 = eval { $dir->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns file object'); }

my $subdir = tempdir(DIR => $temp_dir);
my $result5 = eval { $dir->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result5, 'Function returns directory object'); }

done_testing();