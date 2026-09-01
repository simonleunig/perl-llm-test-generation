use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::as_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'as_foreign is defined'); }

my $dir = Path::Class::Dir->new('t');
my $foreign_dir = eval { $dir->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed: ' . $@); } else { ok(defined $foreign_dir, 'as_foreign returns a result'); }

my $invalid_foreign_dir = eval { $dir->as_foreign('InvalidType') };
if ($@) { like($@, qr/Can't locate File\/Spec\/InvalidType\.pm/, 'as_foreign throws an error for invalid type'); } else { fail('as_foreign did not throw an error for invalid type'); }

my $empty_dir = Path::Class::Dir->new('');
my $foreign_empty_dir = eval { $empty_dir->as_foreign('Unix') };
if ($@) { fail('as_foreign crashed for empty directory: ' . $@); } else { ok(defined $foreign_empty_dir, 'as_foreign returns a result for empty directory'); }

done_testing();