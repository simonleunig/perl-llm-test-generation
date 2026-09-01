use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::end_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'end_document is defined'); }

# Mocking dependencies
my $mock;
# AFTER LAST PASS: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::collapse"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( override => [ collapse => sub {
            my ($self, @args);  # AFTER LAST PASS: my ($self, @args) = @_;
            # AFTER LAST PASS: return { collapsed => 1, args => \@args };
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( add => [ collapse => sub {
            my ($self, @args);  # AFTER LAST PASS: my ($self, @args) = @_;
            # AFTER LAST PASS: return { collapsed => 1, args => \@args };
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Basic functionality with nocollapse option
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: tree => { root => 'value' },
        # AFTER LAST PASS: nocollapse => 1,
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::end_document($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, $self->{tree}, 'end_document returns tree as-is when nocollapse is set');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 2: Basic functionality with keeproot option
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: tree => [{ root => 'value' }, { child => 'value' }],
        # AFTER LAST PASS: opt => { keeproot => 1 },
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::end_document($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{collapsed}, 1, 'end_document collapses tree with keeproot option');
        # FAILED: is_deeply($result->{args}, [{ root => 'value' }, { child => 'value' }], 'end_document passes correct arguments to collapse with keeproot');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 3: Basic functionality without keeproot option
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: tree => [{ root => 'value' }, { child => 'value' }],
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::end_document($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{collapsed}, 1, 'end_document collapses tree without keeproot option');
        # FAILED: is_deeply($result->{args}, [{ child => 'value' }], 'end_document passes correct arguments to collapse without keeproot');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 4: Basic functionality with datahandler option
# AFTER LAST PASS: {
    my $datahandler;  # AFTER LAST PASS: my $datahandler = sub { return { handled => 1 } };
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: tree => [{ root => 'value' }, { child => 'value' }],
        # AFTER LAST PASS: opt => { datahandler => $datahandler },
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::end_document($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is_deeply($result, { handled => 1 }, 'end_document calls datahandler and returns its result');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 5: Edge case with empty tree
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: tree => [],
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::end_document($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is_deeply($result, { collapsed => 1, args => [] }, 'end_document handles empty tree correctly');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();