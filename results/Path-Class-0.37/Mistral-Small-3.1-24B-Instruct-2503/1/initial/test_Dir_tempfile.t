use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::tempfile"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'tempfile is defined'); }

# Mocking the stringify method of Path::Class::Dir
mock 'Path::Class::Dir' => (
    override => [
        stringify => sub { return 'mocked_directory_path' }
    ]
);

# Mocking File::Temp::tempfile
mock 'File::Temp' => (
    override => [
        tempfile => sub {
            my ($class, %args) = @_;
            if ($args{DIR} eq 'mocked_directory_path') {
                return (undef, 'mocked_tempfile_path');
            } else {
                die "Invalid directory";
            }
        }
    ]
);

# Test case: Successful creation of a temporary file
{
    my $dir = Path::Class::Dir->new('some_directory');
    my $result = eval { $dir->tempfile() };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'tempfile returns a result');
        is($result, 'mocked_tempfile_path', 'tempfile returns the correct filename');
    }
}

# Test case: Error handling when directory is invalid
{
    mock 'Path::Class::Dir' => (
        override => [
            stringify => sub { return 'invalid_directory_path' }
        ]
    );

    my $dir = Path::Class::Dir->new('some_directory');
    my $result = eval { $dir->tempfile() };
    if ($@) {
        like($@, qr/Invalid directory/, 'tempfile handles invalid directory correctly');
    } else {
        fail('Function did not crash as expected');
    }
}

# Clean up mocks
unmock 'Path::Class::Dir';
unmock 'File::Temp';

done_testing();
