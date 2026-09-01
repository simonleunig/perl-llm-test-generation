use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir_class"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir_class is defined'); }

my $result = eval { Path::Class::File::dir_class() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

is($result, 'Path::Class::Dir', 'dir_class returns the correct class name');

done_testing();