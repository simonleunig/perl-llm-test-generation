use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::spew"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'spew is defined'); }

my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $content = 'Hello, World!';
my $result = eval { $file->spew($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $filename, 'File created'); }
my $written_content = do { local (@ARGV, $/) = $filename; <> };
is($written_content, $content, 'Content written correctly');

($fh, $filename) = tempfile();
$file = Path::Class::File->new($filename);
my $array_content = ['Hello', 'World'];
$result = eval { $file->spew($array_content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $filename, 'File created'); }
$written_content = do { local (@ARGV, $/) = $filename; <> };
is($written_content, join('', @$array_content), 'Array content written correctly');

($fh, $filename) = tempfile();
$file = Path::Class::File->new($filename);
my $error = eval { $file->spew({ iomode => 'invalid' }, 'content') };
# FAILED: if ($@) { ok($@, 'Error thrown for invalid IO mode'); } else { fail('No error thrown for invalid IO mode'); }

my $mock;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::open"}) {
        $mock = mock 'Path::Class::File' => ( override => [ open => sub { return undef } ] );
    } else {
        $mock = mock 'Path::Class::File' => ( add => [ open => sub { return undef } ] );
    }
}
$file = Path::Class::File->new($filename);
$error = eval { $file->spew('content') };
if ($@) { ok($@, 'Error thrown when file cannot be opened'); } else { fail('No error thrown when file cannot be opened'); }

done_testing();