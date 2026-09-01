use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::mkpath"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'mkpath is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->mkpath() };
if ($@) { fail('mkpath crashed: ' . $@); } else { ok(defined $result, 'mkpath returns result'); }

$result = eval { $dir->mkpath() };
if ($@) { fail('mkpath crashed on existing directory: ' . $@); } else { ok(defined $result, 'mkpath returns result on existing directory'); }

my $invalid_dir = Path::Class::Dir->new('');
my $error = eval { $invalid_dir->mkpath() };
if ($@) { like($@, qr/No such file or directory/, 'mkpath throws error on invalid directory path'); } else { fail('mkpath did not throw error on invalid directory path'); }

my $mock_mkdir;
eval { require File::Path; };
if ($@) {
    # DEPENDENCY MISSING: File::Path - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Path::mkpath"}) {
        $mock_mkdir = mock 'File::Path' => (override => [mkpath => sub { die 'permissions error' }]);
    } else {
        $mock_mkdir = mock 'File::Path' => (add => [mkpath => sub { die 'permissions error' }]);
    }
}

my $permissions_dir = Path::Class::Dir->new(tempdir(CLEANUP => 1));
$error = eval { $permissions_dir->mkpath() };
if ($@) { like($@, qr/permissions error/, 'mkpath throws error on permissions error'); } else { fail('mkpath did not throw error on permissions error'); }

done_testing();