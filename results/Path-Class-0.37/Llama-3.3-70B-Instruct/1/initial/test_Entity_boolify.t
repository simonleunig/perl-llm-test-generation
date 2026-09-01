use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::boolify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'boolify is defined'); }

# Test cases with eval protection
my $entity = bless {}, 'Path::Class::Entity';
my $result = eval { Path::Class::Entity::boolify($entity) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'boolify returns 1'); }

# Test boolify in boolean context
my $bool_context = eval { !!$entity };
if ($@) { fail('Boolean context crashed: ' . $@); } else { ok($bool_context, 'Entity is true in boolean context'); }

done_testing();
