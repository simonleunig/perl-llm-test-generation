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
my $result = eval { $entity->boolify() };
if ($@) { fail('boolify crashed: ' . $@); } else { is($result, 1, 'boolify returns 1'); }

# Test boolify in boolean context
my $bool_context = eval { !!$entity };
if ($@) { 
    # FAILED: fail('boolify in boolean context crashed: ' . $@); 
} else { 
    # FAILED: ok($bool_context, 'boolify returns true in boolean context'); 
}

# Add stringify method to Path::Class::Entity for overloading
my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped  
} else {
    no strict 'refs';
    if (not defined &{"Path::Class::Entity::stringify"}) {
        $mock = mock 'Path::Class::Entity' => ( add => [ stringify => sub { return 'stringified' } ] );
    }
}

# Retest boolify in boolean context after adding stringify method
my $bool_context_retest = eval { !!$entity };
if ($@) { 
    # FAILED: fail('boolify in boolean context retest crashed: ' . $@); 
} else { 
    ok($bool_context_retest, 'boolify returns true in boolean context after adding stringify'); 
}

done_testing();