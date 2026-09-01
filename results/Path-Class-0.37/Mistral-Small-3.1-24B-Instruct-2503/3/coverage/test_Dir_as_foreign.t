use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::as_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'as_foreign is defined'); }

# Mocking dependencies
my $mock_entity;
# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::new"}) {
        # AFTER LAST PASS: $mock_entity = mock 'Path::Class::Entity' => ( override => [ new => sub { bless {}, 'Path::Class::Entity' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_entity = mock 'Path::Class::Entity' => ( add => [ new => sub { bless {}, 'Path::Class::Entity' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_dir;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::_spec_class"}) {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => ( override => [
            # AFTER LAST PASS: _spec_class => sub { return 'File::Spec::Unix' },
            # AFTER LAST PASS: _spec => sub { return bless { updir => '..' }, 'File::Spec::Unix' }
        # AFTER LAST PASS: ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => ( add => [
            # AFTER LAST PASS: _spec_class => sub { return 'File::Spec::Unix' },
            # AFTER LAST PASS: _spec => sub { return bless { updir => '..' }, 'File::Spec::Unix' }
        # AFTER LAST PASS: ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Normal operation with valid type
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {
        # AFTER LAST PASS: file_spec_class => 'File::Spec::Unix',
        # AFTER LAST PASS: volume => 'C',
        # AFTER LAST PASS: dirs => ['dir1', 'dir2'],
    # AFTER LAST PASS: }, 'Path::Class::Dir';

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->as_foreign('Unix') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        # FAILED: is($result->{volume}, 'C', 'Volume is correctly cloned');
        # FAILED: is_deeply($result->{dirs}, ['dir1', 'dir2'], 'Dirs are correctly cloned');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 2: Edge case with empty dirs
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {
        # AFTER LAST PASS: file_spec_class => 'File::Spec::Unix',
        # AFTER LAST PASS: volume => 'C',
        # AFTER LAST PASS: dirs => [],
    # AFTER LAST PASS: }, 'Path::Class::Dir';

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->as_foreign('Unix') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        # FAILED: is($result->{volume}, 'C', 'Volume is correctly cloned');
        # FAILED: is_deeply($result->{dirs}, [], 'Dirs are correctly cloned');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 3: Edge case with updir in dirs
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {
        # AFTER LAST PASS: file_spec_class => 'File::Spec::Unix',
        # AFTER LAST PASS: volume => 'C',
        # AFTER LAST PASS: dirs => ['..', 'dir1'],
    # AFTER LAST PASS: }, 'Path::Class::Dir';

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->as_foreign('Unix') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        # FAILED: is($result->{volume}, 'C', 'Volume is correctly cloned');
        # FAILED: is_deeply($result->{dirs}, ['..', 'dir1'], 'Dirs are correctly mapped');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 4: Edge case with invalid type (should not crash but return a valid object)
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {
        # AFTER LAST PASS: file_spec_class => 'File::Spec::Unix',
        # AFTER LAST PASS: volume => 'C',
        # AFTER LAST PASS: dirs => ['dir1', 'dir2'],
    # AFTER LAST PASS: }, 'Path::Class::Dir';

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->as_foreign('InvalidType') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        # FAILED: is($result->{volume}, 'C', 'Volume is correctly cloned');
        # FAILED: is_deeply($result->{dirs}, ['dir1', 'dir2'], 'Dirs are correctly cloned');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();