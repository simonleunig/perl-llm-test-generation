use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::end_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'end_document is defined'); }

# Mocking dependencies
mock 'XML::Simple' => (
    collapse => sub {
        my ($self, @args) = @_;
        return { collapsed => 1, args => \@args };
    },
);

# Test case 1: Basic functionality with nocollapse option
{
    my $self = bless {
        tree => { root => 'value' },
        nocollapse => 1,
    }, 'XML::Simple';

    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { root => 'value' }, 'end_document returns raw tree when nocollapse is set');
    }
}

# Test case 2: Basic functionality with keeproot option
{
    my $self = bless {
        tree => [{ root => 'value' }, { child => 'value' }],
        opt => { keeproot => 1 },
    }, 'XML::Simple';

    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { collapsed => 1, args => [{ root => 'value' }, { child => 'value' }] }, 'end_document collapses tree with keeproot');
    }
}

# Test case 3: Basic functionality without keeproot option
{
    my $self = bless {
        tree => [{ root => 'value' }, { child => 'value' }],
    }, 'XML::Simple';

    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { collapsed => 1, args => [{ child => 'value' }] }, 'end_document collapses tree without keeproot');
    }
}

# Test case 4: Basic functionality with datahandler option
{
    my $datahandler_called = 0;
    my $self = bless {
        tree => { root => 'value' },
        opt => {
            datahandler => sub {
                $datahandler_called = 1;
                return { handled => 1 };
            },
        },
    }, 'XML::Simple';

    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { handled => 1 }, 'end_document calls datahandler and returns its result');
        ok($datahandler_called, 'datahandler was called');
    }
}

# Test case 5: Edge case with empty tree
{
    my $self = bless {
        tree => [],
    }, 'XML::Simple';

    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, { collapsed => 1, args => [] }, 'end_document handles empty tree');
    }
}

done_testing();
