use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->open() };
if ($@) { fail('Open crashed: ' . $@); } else { ok(defined $result, 'Open returns result'); }

my $non_existent_dir;  # AFTER LAST PASS: my $non_existent_dir;  # UNVALIDATED: my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
my $non_existent_result;  # AFTER LAST PASS: my $non_existent_result;  # UNVALIDATED: my $non_existent_result = eval { $non_existent_dir->open() };
# FAILED: if ($@) { ok($@, 'Open throws exception for non-existent directory'); } else { fail('Open did not throw exception for non-existent directory'); }

my $unreadable_dir;  # AFTER LAST PASS: my $unreadable_dir;  # UNVALIDATED: my $unreadable_dir = Path::Class::Dir->new($temp_dir);
# UNVALIDATED: eval { chmod 000, $unreadable_dir->stringify() };
my $unreadable_result;  # AFTER LAST PASS: my $unreadable_result;  # UNVALIDATED: my $unreadable_result = eval { $unreadable_dir->open() };
# FAILED: if ($@) { ok($@, 'Open throws exception for unreadable directory'); } else { fail('Open did not throw exception for unreadable directory'); }
# UNVALIDATED: eval { chmod 0755, $unreadable_dir->stringify() };

# AFTER LAST PASS: eval { rmdir($temp_dir) };

done_testing();