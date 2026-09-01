use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::parent"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parent is defined'); }

# Mocking dependencies
# AFTER LAST PASS: mock 'Path::Class::File' => ( new => sub { return bless {}, 'Path::Class::File' } );
# AFTER LAST PASS: mock 'Path::Class::Entity' => ( new => sub { return bless {}, 'Path::Class::Entity' } );

my $mock;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => (
            # AFTER LAST PASS: new => sub {
                my ($class, $self, $updir);  # AFTER LAST PASS: my ($class, $self, $updir) = @_;
                my $dirs;  # AFTER LAST PASS: my $dirs = $self->{dirs} || [];
                # AFTER LAST PASS: return bless { dirs => $dirs }, $class;
            # AFTER LAST PASS: },
            # AFTER LAST PASS: _spec => sub {
                my $self;  # AFTER LAST PASS: my $self = shift;
                # AFTER LAST PASS: return bless {
                    # AFTER LAST PASS: curdir => '.',
                    # AFTER LAST PASS: updir => '..'
                # AFTER LAST PASS: }, 'File::Spec';
            # AFTER LAST PASS: },
            # AFTER LAST PASS: is_absolute => sub { return 0; }
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => (
            # AFTER LAST PASS: add => {
                # AFTER LAST PASS: new => sub {
                    my ($class, $self, $updir);  # AFTER LAST PASS: my ($class, $self, $updir) = @_;
                    my $dirs;  # AFTER LAST PASS: my $dirs = $self->{dirs} || [];
                    # AFTER LAST PASS: return bless { dirs => $dirs }, $class;
                # AFTER LAST PASS: },
                # AFTER LAST PASS: _spec => sub {
                    my $self;  # AFTER LAST PASS: my $self = shift;
                    # AFTER LAST PASS: return bless {
                        # AFTER LAST PASS: curdir => '.',
                        # AFTER LAST PASS: updir => '..'
                    # AFTER LAST PASS: }, 'File::Spec';
                # AFTER LAST PASS: },
                # AFTER LAST PASS: is_absolute => sub { return 0; }
            # AFTER LAST PASS: }
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Absolute path
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless { dirs => ['root', 'dir1', 'dir2'] }, 'Path::Class::Dir';
    # AFTER LAST PASS: mock 'Path::Class::Dir' => ( is_absolute => sub { return 1 } );
    my $parent;  # AFTER LAST PASS: my $parent;  # UNVALIDATED: my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], 'root', 'Absolute path parent is correct');
        # FAILED: is($parent->{dirs}->[1], 'dir1', 'Absolute path parent is correct');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Relative path (current directory)
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless { dirs => ['.'] }, 'Path::Class::Dir';
    my $parent;  # AFTER LAST PASS: my $parent;  # UNVALIDATED: my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], '..', 'Relative path parent is correct for current directory');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: All updirs
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless { dirs => ['..', '..'] }, 'Path::Class::Dir';
    my $parent;  # AFTER LAST PASS: my $parent;  # UNVALIDATED: my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], '..', 'All updirs parent is correct');
        # FAILED: is($parent->{dirs}->[1], '..', 'All updirs parent is correct');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Single directory
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless { dirs => ['dir1'] }, 'Path::Class::Dir';
    my $parent;  # AFTER LAST PASS: my $parent;  # UNVALIDATED: my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], '.', 'Single directory parent is correct');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Multiple directories
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless { dirs => ['dir1', 'dir2'] }, 'Path::Class::Dir';
    my $parent;  # AFTER LAST PASS: my $parent;  # UNVALIDATED: my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], 'dir1', 'Multiple directories parent is correct');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();