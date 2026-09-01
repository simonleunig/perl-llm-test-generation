use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock unmock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_simple_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_simple_tree is defined'); }

# Mock dependencies
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::build_tree"}) {
        $mock = mock 'XML::Simple' => ( override => [
            build_tree => sub { return [1, [2, 3]] },
            collapse   => sub { return { key => 'value' } },
        ]);
    } else {
        $mock = mock 'XML::Simple' => ( add => [
            build_tree => sub { return [1, [2, 3]] },
            collapse   => sub { return { key => 'value' } },
        ]);
    }
}

# Test case 1: Normal operation with keeproot option
{
    my $self = bless { opt => { keeproot => 1 } }, 'XML::Simple';
    my $result = eval { $self->build_simple_tree() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { key => 'value' }, 'build_simple_tree returns correct result with keeproot');
    }
}

# Test case 2: Normal operation without keeproot option
{
    my $self = bless { opt => { keeproot => 0 } }, 'XML::Simple';
    my $result = eval { $self->build_simple_tree() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { key => 'value' }, 'build_simple_tree returns correct result without keeproot');
    }
}

# Test case 3: Error handling with invalid XML input
{
    unmock 'XML::Simple';
    mock 'XML::Simple' => (
        build_tree => sub { die 'Invalid XML' },
    );

    my $self = bless { opt => { keeproot => 1 } }, 'XML::Simple';
    my $result = eval { $self->build_simple_tree() };
    if ($@) {
        like($@, qr/XML::Simple called/, 'build_simple_tree handles invalid XML input correctly');
    } else {
        fail('Function did not crash with invalid XML input');
    }
}

# Test case 4: Edge case with empty input
{
    unmock 'XML::Simple';
    mock 'XML::Simple' => (
        build_tree => sub { return [] },
    );

    my $self = bless { opt => { keeproot => 1 } }, 'XML::Simple';
    my $result = eval { $self->build_simple_tree() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, {}, 'build_simple_tree handles empty input correctly');
    }
}

done_testing();