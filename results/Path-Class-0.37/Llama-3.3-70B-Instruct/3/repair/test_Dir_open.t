use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Test case: Successful directory opening
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->open() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'open returns result on success'); }
unlink for glob "$temp_dir/*";
rmdir $temp_dir;

# Test case: Directory does not exist
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
$result = eval { $non_existent_dir->open() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'open returns undef on non-existent directory'); }

# Test case: Permission denied
my $permission_denied_dir = tempdir();
chmod 000, $permission_denied_dir;
my $dir_obj = Path::Class::Dir->new($permission_denied_dir);
$result = eval { $dir_obj->open() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'open returns undef on permission denied'); }
chmod 0700, $permission_denied_dir;
rmdir $permission_denied_dir;

done_testing();
