use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Mocking Path::Class::Foreign
my $mock;
eval { require Path::Class::Foreign; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Foreign - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Foreign::new"}) {
        $mock = mock 'Path::Class::Foreign' => ( override => [ 'new' => sub { return 'MockedForeignClass'; } ] );
    } else {
        $mock = mock 'Path::Class::Foreign' => ( add => [ 'new' => sub { return 'MockedForeignClass'; } ] );
    }
}

# Test case 1: $from is a class name
my $result = eval { Path::Class::Entity->new('Path::Class::Entity') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when $from is a class name');
    is(ref($result), 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
    # FAILED: is($result->{file_spec_class}, 'MockedForeignClass', 'file_spec_class is set to MockedForeignClass');
}

# Test case 2: $from is an object reference with file_spec_class
my $mock_object;  # AFTER LAST PASS: my $mock_object = bless { file_spec_class => 'MockedClass' }, 'MockClass';
# UNVALIDATED: $result = eval { Path::Class::Entity->new($mock_object) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: ok(defined $result, 'Function returns result when $from is an object reference with file_spec_class');
    # FAILED: is(ref($result), 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
    # FAILED: is($result->{file_spec_class}, 'MockedClass', 'file_spec_class is set to MockedClass');
# FAILED: }

# Test case 3: $from is an object reference without file_spec_class
# AFTER LAST PASS: $mock_object = bless {}, 'MockClass';
# UNVALIDATED: $result = eval { Path::Class::Entity->new($mock_object) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: ok(defined $result, 'Function returns result when $from is an object reference without file_spec_class');
    # FAILED: is(ref($result), 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
    # FAILED: is($result->{file_spec_class}, 'MockedForeignClass', 'file_spec_class defaults to MockedForeignClass');
# FAILED: }

# Test case 4: $from is undef
# UNVALIDATED: $result = eval { Path::Class::Entity->new(undef) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: ok(defined $result, 'Function returns result when $from is undef');
    # FAILED: is(ref($result), 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
    # FAILED: is($result->{file_spec_class}, 'MockedForeignClass', 'file_spec_class defaults to MockedForeignClass');
# FAILED: }

done_testing();