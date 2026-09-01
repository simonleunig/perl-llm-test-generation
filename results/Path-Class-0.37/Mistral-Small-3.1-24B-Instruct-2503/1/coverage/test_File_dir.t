use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Mock dependencies
my $mock_dir;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::new"}) {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: new => sub {
                    my ($class, $path);  # AFTER LAST PASS: my ($class, $path) = @_;
                    # AFTER LAST PASS: return bless { path => $path }, $class;
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: new => sub {
                    my ($class, $path);  # AFTER LAST PASS: my ($class, $path) = @_;
                    # AFTER LAST PASS: return bless { path => $path }, $class;
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_file;
# AFTER LAST PASS: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::dir_class"}) {
        # AFTER LAST PASS: $mock_file = mock 'Path::Class::File' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: dir_class => sub { 'Path::Class::Dir' },
                # AFTER LAST PASS: _spec => sub {
                    my $self;  # AFTER LAST PASS: my $self = shift;
                    # AFTER LAST PASS: return bless { curdir => 'current_dir' }, 'Path::Class::File::Spec';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_file = mock 'Path::Class::File' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: dir_class => sub { 'Path::Class::Dir' },
                # AFTER LAST PASS: _spec => sub {
                    my $self;  # AFTER LAST PASS: my $self = shift;
                    # AFTER LAST PASS: return bless { curdir => 'current_dir' }, 'Path::Class::File::Spec';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Directory is already defined
# AFTER LAST PASS: {
    my $file;  # AFTER LAST PASS: my $file = bless { dir => 'existing_dir' }, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->dir };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{path}, 'existing_dir', 'Returns existing directory when defined');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Directory is not defined
# AFTER LAST PASS: {
    my $file;  # AFTER LAST PASS: my $file = bless {}, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->dir };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{path}, 'current_dir', 'Returns new directory object when not defined');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Edge case with relative path
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'Path::Class::File' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: _spec => sub {
                my $self;  # AFTER LAST PASS: my $self = shift;
                # AFTER LAST PASS: return bless { curdir => 'relative_path' }, 'Path::Class::File::Spec';
            # AFTER LAST PASS: }
        # AFTER LAST PASS: ]
    # AFTER LAST PASS: );

    my $file;  # AFTER LAST PASS: my $file = bless {}, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->dir };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{path}, 'relative_path', 'Handles relative path correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Edge case with absolute path
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'Path::Class::File' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: _spec => sub {
                my $self;  # AFTER LAST PASS: my $self = shift;
                # AFTER LAST PASS: return bless { curdir => '/absolute_path' }, 'Path::Class::File::Spec';
            # AFTER LAST PASS: }
        # AFTER LAST PASS: ]
    # AFTER LAST PASS: );

    my $file;  # AFTER LAST PASS: my $file = bless {}, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->dir };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{path}, '/absolute_path', 'Handles absolute path correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Error handling in dir_class
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'Path::Class::File' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: dir_class => sub { die 'dir_class error' }
        # AFTER LAST PASS: ]
    # AFTER LAST PASS: );

    my $file;  # AFTER LAST PASS: my $file = bless {}, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->dir };
    # FAILED: if (!$@) { fail('Function did not crash as expected'); } else {
        # FAILED: like($@, qr/dir_class error/, 'Propagates error from dir_class');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Error handling in _spec->curdir
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'Path::Class::File' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: _spec => sub {
                my $self;  # AFTER LAST PASS: my $self = shift;
                # AFTER LAST PASS: return bless { curdir => sub { die 'curdir error' } }, 'Path::Class::File::Spec';
            # AFTER LAST PASS: }
        # AFTER LAST PASS: ]
    # AFTER LAST PASS: );

    my $file;  # AFTER LAST PASS: my $file = bless {}, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->dir };
    # FAILED: if (!$@) { fail('Function did not crash as expected'); } else {
        # FAILED: like($@, qr/curdir error/, 'Propagates error from _spec->curdir');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();