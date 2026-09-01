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

# Test case 1: Successful write with scalar content
my $temp_file = File::Temp->new;
my $file_path = $temp_file->filename;
my $file_obj = Path::Class::File->new($file_path);
my $content = "Hello, World!";
eval { $file_obj->spew($content) };
if ($@) { fail('Write with scalar content failed: ' . $@); } else { ok(-f $file_path, 'File created with scalar content'); }

# Test case 2: Successful write with array reference content
my $array_content = ["Line 1", "Line 2", "Line 3"];
eval { $file_obj->spew($array_content) };
if ($@) { fail('Write with array reference content failed: ' . $@); } else { ok(-f $file_path, 'File created with array reference content'); }

# Test case 3: Error handling for non-existent file
my $non_existent_file = Path::Class::File->new("non_existent_file.txt");
eval { $non_existent_file->spew("Content") };
if ($@) { ok($@, 'Error thrown for non-existent file'); } else { fail('No error thrown for non-existent file'); }

# Test case 4: Error handling for invalid content type
my $invalid_content = { key => "value" };
eval { $file_obj->spew($invalid_content) };
if ($@) { ok($@, 'Error thrown for invalid content type'); } else { fail('No error thrown for invalid content type'); }

# Clean up
unlink $file_path;

done_testing();
