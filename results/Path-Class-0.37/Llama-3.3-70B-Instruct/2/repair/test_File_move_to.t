use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::move_to"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'move_to is defined'); }

my ($fh, $filename) = tempfile();
my $dir = tempdir();
my $file = Path::Class::File->new($filename);
my $dest = Path::Class::File->new("$dir/test.txt");
my $result = eval { $file->move_to($dest) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(defined $result, 'move_to returns result'); }

my ($fh2, $filename2) = tempfile();
my $file2 = Path::Class::File->new($filename2);
my $dest2 = Path::Class::File->new("/non/existent/path");
my $result2 = eval { $file2->move_to($dest2) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(!defined $result2, 'move_to returns undef on failure'); }

my $result3 = eval { Path::Class::File->new('test.txt')->move_to(Path::Class::File->new('/non/existent/path')) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(!defined $result3, 'move_to returns undef with invalid input'); }

my $error = eval { Path::Class::File->move_to() };
ok($@, "Dies with bad input");
like($@, qr/Can't use string "Path::Class::File" as a HASH ref/, "Error message correct");

done_testing();