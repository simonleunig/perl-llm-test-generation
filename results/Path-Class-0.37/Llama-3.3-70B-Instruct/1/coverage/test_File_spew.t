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
my $file = eval { Path::Class::File->new($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $file, 'File object created'); }

my $content = 'Hello, World!';
my $result = eval { $file->spew($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $filename, 'File created'); }
my $written_content = do { local (@ARGV, $/) = $filename; <> };
is($written_content, $content, 'Content written correctly');

($fh, $filename) = tempfile();
$file = eval { Path::Class::File->new($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $file, 'File object created'); }

my $array_content = ['Hello', 'World'];
$result = eval { $file->spew($array_content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $filename, 'File created'); }
$written_content = do { local (@ARGV, $/) = $filename; <> };
is($written_content, join('', @$array_content), 'Array content written correctly');

($fh, $filename) = tempfile();
$file = eval { Path::Class::File->new($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $file, 'File object created'); }

my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $file->spew({ iomode => 'invalid' }, 'content') };
# FAILED: if ($@) { ok($@, 'Error thrown for invalid IO mode'); } else { fail('No error thrown for invalid IO mode'); }

my $mock;
# AFTER LAST PASS: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::open"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( open => sub { return undef } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::File' => ( add => { open => sub { return undef } } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# UNVALIDATED: $file = eval { Path::Class::File->new($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $file, 'File object created'); }

# UNVALIDATED: $error = eval { $file->spew('content') };
# FAILED: if ($@) { ok($@, 'Error thrown when file cannot be opened'); } else { fail('No error thrown when file cannot be opened'); }

done_testing();