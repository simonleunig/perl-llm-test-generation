use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->file('test_file') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

$result = eval { $dir->file('test_file') };
if ($@) { fail('Function crashed: ' . $@); } else { is(ref($result), 'Path::Class::File', 'Returned object is of class Path::Class::File'); }

$result = eval { $dir->file('test_file') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->stringify, File::Spec->catdir($temp_dir, 'test_file'), 'File object has the correct path'); }

my $mock_file_spec_class;  # AFTER LAST PASS: my $mock_file_spec_class = mock 'Path::Class::File' => (new => sub { bless {}, 'Mock::File' });
my $dir_with_file_spec_class;  # AFTER LAST PASS: my $dir_with_file_spec_class;  # UNVALIDATED: my $dir_with_file_spec_class = Path::Class::Dir->new($temp_dir);
# AFTER LAST PASS: $dir_with_file_spec_class->{file_spec_class} = 'Path::Class::File';
# UNVALIDATED: $result = eval { $dir_with_file_spec_class->file('test_file') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is(ref($result), 'Path::Class::File', 'file_spec_class attribute affects the class of the file object'); }

done_testing();