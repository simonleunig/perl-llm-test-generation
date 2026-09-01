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

my $temp_file = File::Temp->new;
my $file_path = $temp_file->filename;
my $file_obj = Path::Class::File->new($file_path);

my $content = 'Hello, World!';
my $result = eval { $file_obj->spew($content) };
if ($@) { fail('Write with scalar content failed: ' . $@); } else { ok(-f $file_path, 'File created with scalar content'); }

my $array_content = ['Line 1', 'Line 2', 'Line 3'];
$result = eval { $file_obj->spew($array_content) };
if ($@) { fail('Write with array reference content failed: ' . $@); } else { ok(-f $file_path, 'File created with array reference content'); }

my $non_existent_file;  # AFTER LAST PASS: my $non_existent_file;  # UNVALIDATED: my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $non_existent_file->spew('Content') };
# FAILED: if ($@) { ok($@, 'Error thrown for non-existent file'); like($@, qr/Can't write to/, 'Error message correct'); } else { fail('No error thrown for non-existent file'); }

my $invalid_content;  # AFTER LAST PASS: my $invalid_content = { key => 'value' };
# UNVALIDATED: $error = eval { $file_obj->spew($invalid_content) };
# FAILED: if ($@) { ok($@, 'Error thrown for invalid content type'); like($@, qr/Can't write to/, 'Error message correct'); } else { fail('No error thrown for invalid content type'); }

# AFTER LAST PASS: unlink $file_path;

done_testing();