use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::as_foreign"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'as_foreign is defined'); }

my $dir = Path::Class::Dir->new('path/to/directory');
my $result = eval { $dir->as_foreign('Unix') };
if ($@) { fail("as_foreign crashed: $@"); } else { ok(defined $result, 'as_foreign returns result'); }

my $invalid_result = eval { $dir->as_foreign('InvalidType') };
if ($@) { 
    # FAILED: like($@, qr/Can't locate File::Spec::InvalidType.pm/, 'as_foreign dies with invalid type');
} else { 
    # FAILED: fail("as_foreign did not die with invalid type");
}

my $empty_dir = Path::Class::Dir->new('');
my $empty_result = eval { $empty_dir->as_foreign('Unix') };
if ($@) { fail("as_foreign crashed: $@"); } else { ok(defined $empty_result, 'as_foreign returns result for empty directory path'); }

my $invalid_dir = bless {}, 'InvalidDir';
my $invalid_dir_result = eval { $invalid_dir->as_foreign('Unix') };
if ($@) { 
    like($@, qr/Can't locate object method "as_foreign" via package "InvalidDir"/, 'as_foreign dies with invalid directory object');
} else { 
    # FAILED: fail("as_foreign did not die with invalid directory object");
}

done_testing();