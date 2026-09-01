use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Mocking dependencies
mock 'Carp' => ( croak => sub { die shift } );
mock 'UNIVERSAL' => ( isa => sub { return 1; } );

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::handle_options"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'handle_options is defined'); }

# Test case: Valid input options for XMLin
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', rootname => 'test_root', contentkey => '-content');
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($self->{opt}->{rootname}, 'test_root', 'rootname set correctly');
        is($self->{opt}->{contentkey}, 'content', 'contentkey set correctly');
        is($self->{opt}->{collapseagain}, 1, 'collapseagain set correctly');
    }
}

# Test case: Valid input options for XMLout
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'out', rootname => 'test_root', contentkey => 'content');
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($self->{opt}->{rootname}, 'test_root', 'rootname set correctly');
        is($self->{opt}->{contentkey}, 'content', 'contentkey set correctly');
    }
}

# Test case: Odd number of options
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', rootname => 'test_root');
    };
    if ($@) { ok($@, 'Function croaked on odd number of options'); } else { fail('Function did not croak on odd number of options'); }
}

# Test case: Unrecognized option
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', unknown_option => 'value');
    };
    if ($@) { ok($@, 'Function croaked on unrecognized option'); } else { fail('Function did not croak on unrecognized option'); }
}

# Test case: Unsupported caching scheme
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {}, can => sub { return 0 } }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', cache => ['unsupported']);
    };
    if ($@) { ok($@, 'Function croaked on unsupported caching scheme'); } else { fail('Function did not croak on unsupported caching scheme'); }
}

# Test case: Deprecated option
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    mock 'warnings' => ( enabled => sub { return 1 } );
    my $result = eval {
        XML::Simple::handle_options($self, 'in', parseropts => []);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(1, 'Function did not croak on deprecated option');
    }
}

# Test case: Special cleanup for forcearray
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', forcearray => ['tag1', qr/tag2/]);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($self->{opt}->{forcearray}), 'HASH', 'forcearray is a hashref');
        is($self->{opt}->{forcearray}->{tag1}, 1, 'tag1 in forcearray');
        is(scalar(@{$self->{opt}->{forcearray}->{_regex}}), 1, 'tag2 regex in forcearray');
    }
}

# Test case: Special cleanup for keyattr
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', keyattr => { elem => '+attr' });
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($self->{opt}->{keyattr}), 'HASH', 'keyattr is a hashref');
        is_deeply($self->{opt}->{keyattr}->{elem}, ['attr', '+'], 'keyattr elem set correctly');
    }
}

# Test case: Special cleanup for valueattr
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', valueattr => ['attr1', 'attr2']);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($self->{opt}->{valueattrlist}), 'HASH', 'valueattrlist is a hashref');
        is($self->{opt}->{valueattrlist}->{attr1}, 1, 'attr1 in valueattrlist');
        is($self->{opt}->{valueattrlist}->{attr2}, 1, 'attr2 in valueattrlist');
    }
}

# Test case: Illegal value for GroupTags
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', grouptags => { 'tag' => 'tag' });
    };
    if ($@) { ok($@, 'Function croaked on illegal GroupTags value'); } else { fail('Function did not croak on illegal GroupTags value'); }
}

# Test case: Illegal value for Variables
{
    my $self = bless { def_opt => { rootname => 'root' }, _var_values => {} }, 'XML::Simple';
    my $result = eval {
        XML::Simple::handle_options($self, 'in', variables => 'not_a_hashref');
    };
    if ($@) { ok($@, 'Function croaked on illegal Variables value'); } else { fail('Function did not croak on illegal Variables value'); }
}

done_testing();
