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
    my $self = {
        tree => { root => 'value' },
        nocollapse => 1,
    };
    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $self->{tree}, 'end_document returns tree as-is when nocollapse is set');
    }
}

# Test case 2: Basic functionality with keeproot option
{
    my $self = {
        tree => [{ root => 'value' }, { child => 'value' }],
        opt => { keeproot => 1 },
    };
    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{collapsed}, 1, 'end_document collapses tree with keeproot option');
        is_deeply($result->{args}, [{ root => 'value' }, { child => 'value' }], 'end_document passes correct arguments to collapse with keeproot');
    }
}

# Test case 3: Basic functionality without keeproot option
{
    my $self = {
        tree => [{ root => 'value' }, { child => 'value' }],
    };
    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{collapsed}, 1, 'end_document collapses tree without keeproot option');
        is_deeply($result->{args}, [{ child => 'value' }], 'end_document passes correct arguments to collapse without keeproot');
    }
}

# Test case 4: Basic functionality with datahandler option
{
    my $datahandler = sub { return { handled => 1 } };
    my $self = {
        tree => [{ root => 'value' }, { child => 'value' }],
        opt => { datahandler => $datahandler },
    };
    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result, { handled => 1 }, 'end_document calls datahandler and returns its result');
    }
}

# Test case 5: Edge case with empty tree
{
    my $self = {
        tree => [],
    };
    my $result = eval { XML::Simple::end_document($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result, { collapsed => 1, args => [] }, 'end_document handles empty tree correctly');
    }
}

done_testing();
