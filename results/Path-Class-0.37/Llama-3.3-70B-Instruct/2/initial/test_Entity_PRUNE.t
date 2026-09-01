use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::PRUNE"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'PRUNE is defined'); }

# Test cases with eval protection
my $result = eval { Path::Class::Entity::PRUNE() };
if ($@) { fail('PRUNE crashed: ' . $@); } else { ok(defined $result, 'PRUNE returns result'); }

# Check if PRUNE returns a reference to itself
my $ref_check = eval { Path::Class::Entity::PRUNE() == \&Path::Class::Entity::PRUNE };
if ($@) { fail('Reference check crashed: ' . $@); } else { ok($ref_check, 'PRUNE returns a reference to itself'); }

done_testing();
