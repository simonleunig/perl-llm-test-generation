use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_dir is defined'); }

# Test case: Check if is_dir returns 0
my $result = eval { Path::Class::Entity->is_dir() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 0, 'is_dir returns 0'); }

done_testing();
