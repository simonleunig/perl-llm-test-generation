use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::spew"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'spew is defined'); }

# Test case 1: Successful write to file
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $content = 'Hello, World!';
eval { $file->spew($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $filename, 'File created'); }
my $written_content = do { local (@ARGV, $/) = $filename; <> };
is($written_content, $content, 'Content written correctly');

# Test case 2: Successful write to file with array reference
($fh, $filename) = tempfile();
$file = Path::Class::File->new($filename);
my $array_content = ['Hello', 'World'];
eval { $file->spew($array_content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $filename, 'File created'); }
$written_content = do { local (@ARGV, $/) = $filename; <> };
is($written_content, join('', @$array_content), 'Array content written correctly');

# Test case 3: Error handling - invalid IO mode
($fh, $filename) = tempfile();
$file = Path::Class::File->new($filename);
eval { $file->spew({ iomode => 'invalid' }, 'content') };
if ($@) { ok($@, 'Error thrown for invalid IO mode'); } else { fail('No error thrown for invalid IO mode'); }

# Test case 4: Error handling - file cannot be opened
mock 'Path::Class::File' => (
    open => sub { return undef },
);
$file = Path::Class::File->new($filename);
eval { $file->spew('content') };
if ($@) { ok($@, 'Error thrown when file cannot be opened'); } else { fail('No error thrown when file cannot be opened'); }

done_testing();
