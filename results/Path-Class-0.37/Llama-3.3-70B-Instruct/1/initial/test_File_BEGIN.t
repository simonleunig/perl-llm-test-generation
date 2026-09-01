use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::parent"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parent is defined'); }

# Test cases with eval protection
my $result = eval { Path::Class::File->new('test.txt')->parent };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'parent returns result'); }

# Test parent method returns a Path::Class::Dir object
my $parent_dir = eval { Path::Class::File->new('test.txt')->parent };
if ($@) { fail('Function crashed: ' . $@); } else { ok($parent_dir->isa('Path::Class::Dir'), 'parent returns a Path::Class::Dir object'); }

# Test edge case where file does not exist
my $non_existent_file = eval { Path::Class::File->new('non_existent_file.txt')->parent };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $non_existent_file, 'parent returns result for non-existent file'); }

done_testing();
