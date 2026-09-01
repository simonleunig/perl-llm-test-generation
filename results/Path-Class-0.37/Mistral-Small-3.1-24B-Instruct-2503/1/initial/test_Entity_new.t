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
mock 'Path::Class::Foreign' => ( sub { return 'MockedForeignClass'; } );

# Test case 1: $from is a class name
my $result = eval { Path::Class::Entity->new('Path::Class::Entity') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when $from is a class name');
    is(ref($result), 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
    is($result->{file_spec_class}, 'MockedForeignClass', 'file_spec_class is set to MockedForeignClass');
}

# Test case 2: $from is an object reference with file_spec_class
my $mock_object = bless { file_spec_class => 'MockedClass' }, 'MockClass';
$result = eval { Path::Class::Entity->new($mock_object) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when $from is an object reference with file_spec_class');
    is(ref($result), 'MockClass', 'Result is a MockClass object');
    is($result->{file_spec_class}, 'MockedClass', 'file_spec_class is set to MockedClass');
}

# Test case 3: $from is an object reference without file_spec_class
$mock_object = bless {}, 'MockClass';
$result = eval { Path::Class::Entity->new($mock_object) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when $from is an object reference without file_spec_class');
    is(ref($result), 'MockClass', 'Result is a MockClass object');
    is($result->{file_spec_class}, 'MockedForeignClass', 'file_spec_class defaults to MockedForeignClass');
}

# Test case 4: $from is undef
$result = eval { Path::Class::Entity->new(undef) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when $from is undef');
    is(ref($result), 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
    is($result->{file_spec_class}, 'MockedForeignClass', 'file_spec_class defaults to MockedForeignClass');
}

done_testing();
