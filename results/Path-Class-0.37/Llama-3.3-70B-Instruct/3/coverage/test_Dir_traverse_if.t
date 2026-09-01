use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->traverse_if(sub { 1 }, sub { 1 }) };
if ($@) { fail('Traverse with always-true condition crashed: ' . $@); } else { ok(defined $result, 'Traverse with always-true condition returns result'); }

$result = eval { $dir->traverse_if(sub { 1 }, sub { 0 }) };
if ($@) { fail('Traverse with always-false condition crashed: ' . $@); } else { ok(defined $result, 'Traverse with always-false condition returns result'); }

my $file1 = Path::Class::File->new($temp_dir, 'file1.txt');
my $file2 = Path::Class::File->new($temp_dir, 'file2.txt');
$file1->touch;
$file2->touch;
$result = eval { $dir->traverse_if(sub { 1 }, sub { $_[0]->basename eq 'file1.txt' }) };
if ($@) { fail('Traverse with conditional condition crashed: ' . $@); } else { ok(defined $result, 'Traverse with conditional condition returns result'); }

my $error = eval { $dir->traverse_if(sub { 1 }, 'invalid_condition') };
if ($@) { like($@, qr/Can't use string .* as a subroutine ref/, 'Traverse with invalid condition throws error'); } else { fail('Traverse with invalid condition did not throw error'); }

done_testing();