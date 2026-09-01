use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::tempfile"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'tempfile is defined'); }

my $temp_dir = eval { Path::Class::Dir->new(tempdir()) };
if ($@) { fail('Failed to create temporary directory: ' . $@); } else { ok(defined $temp_dir, 'Temporary directory created'); }

my $result = eval { $temp_dir->tempfile() };
if ($@) { fail('tempfile function crashed: ' . $@); } else { ok(defined $result, 'tempfile function returns result'); }

my $result_with_args = eval { $temp_dir->tempfile('arg1', 'arg2') };
if ($@) { fail('tempfile function with arguments crashed: ' . $@); } else { ok(defined $result_with_args, 'tempfile function with arguments returns result'); }

my $mock;
eval { require File::Temp; };
if ($@) {
    # DEPENDENCY MISSING: File::Temp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Temp::tempfile"}) {
        $mock = mock 'File::Temp' => ( override => [ tempfile => sub { die 'Mocked error' } ] );
    } else {
        $mock = mock 'File::Temp' => ( add => [ tempfile => sub { die 'Mocked error' } ] );
    }
}

my $error_result = eval { $temp_dir->tempfile() };
if ($@) { ok($@ =~ /Mocked error/, 'Error handling works'); } else { fail('Error handling failed'); }

done_testing();