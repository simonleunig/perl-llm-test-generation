use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

# Mocking dependencies
my $mock_file;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::new"}) {
        $mock_file = mock 'Path::Class::File' => (
            override => [
                new => sub {
                    my ($class, @args) = @_;
                    return bless { args => \@args }, $class;
                },
            ],
        );
    } else {
        $mock_file = mock 'Path::Class::File' => (
            add => [
                new => sub {
                    my ($class, @args) = @_;
                    return bless { args => \@args }, $class;
                },
            ],
        );
    }
}

my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::file_class"}) {
        $mock_entity = mock 'Path::Class::Entity' => (
            override => [
                file_class => sub {
                    return 'Path::Class::File';
                },
            ],
        );
    } else {
        $mock_entity = mock 'Path::Class::Entity' => (
            add => [
                file_class => sub {
                    return 'Path::Class::File';
                },
            ],
        );
    }
}

# Test case: Normal operation with valid directory object and file name
{
    my $dir = bless { file_spec_class => undef }, 'Path::Class::Dir';
    my $result = eval { $dir->file('testfile.txt') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
        is($result->{args}[0], 'testfile.txt', 'File name is passed correctly');
    }
}

# Test case: No additional arguments
{
    my $dir = bless { file_spec_class => undef }, 'Path::Class::Dir';
    my $result = eval { $dir->file() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
        is_deeply($result->{args}, [], 'No arguments passed');
    }
}

# Test case: Directory object with file_spec_class
{
    my $dir = bless { file_spec_class => 'Some::FileSpecClass' }, 'Path::Class::Dir';
    my $result = eval { $dir->file('testfile.txt') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
        is($result->{args}[0], 'testfile.txt', 'File name is passed correctly');
        is($Path::Class::Foreign, 'Some::FileSpecClass', 'Path::Class::Foreign is set correctly');
    }
}

# Test case: Invalid directory object (not a Path::Class::Dir object)
{
    my $result = eval { bless {}, 'Some::OtherClass'->file('testfile.txt') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'Function returns undef for invalid directory object');
    }
}

done_testing();