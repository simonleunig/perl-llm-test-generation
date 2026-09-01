use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

my $file = bless { dir => bless({}, 'Path::Class::Dir') }, 'Path::Class::File';
my $mock_volume;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::volume"}) {
        $mock_volume = mock 'Path::Class::Dir' => ( override => [ volume => 'mock_volume' ] );
    } else {
        $mock_volume = mock 'Path::Class::Dir' => ( add => [ volume => 'mock_volume' ] );
    }
}
my $result = eval { $file->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'mock_volume', 'Volume is defined'); }

my $file_no_dir = bless {}, 'Path::Class::File';
$result = eval { $file_no_dir->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Volume is not defined'); }

my $file_dir_error = bless { dir => bless({}, 'Path::Class::Dir') }, 'Path::Class::File';
my $mock_error;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::volume"}) {
        $mock_error = mock 'Path::Class::Dir' => ( override => [ volume => sub { die 'Mock error' } ] );
    } else {
        $mock_error = mock 'Path::Class::Dir' => ( add => [ volume => sub { die 'Mock error' } ] );
    }
}
$result = eval { $file_dir_error->volume() };
if ($@) { ok($@, 'Volume method error'); like($@, qr/Mock error/, 'Error message correct'); } else { fail('Volume method did not die'); }

done_testing();