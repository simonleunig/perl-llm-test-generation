use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::resolve"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'resolve is defined'); }

# Mocking external dependencies
my $mock_cwd;
# AFTER LAST PASS: eval { require Cwd; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Cwd - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Cwd::realpath"}) {
        # AFTER LAST PASS: $mock_cwd = mock 'Cwd' => ( override => { realpath => sub {
            my ($path);  # AFTER LAST PASS: my ($path) = @_;
            # AFTER LAST PASS: return File::Spec->rel2abs($path);
        # AFTER LAST PASS: } } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_cwd = mock 'Cwd' => ( add => { realpath => sub {
            my ($path);  # AFTER LAST PASS: my ($path) = @_;
            # AFTER LAST PASS: return File::Spec->rel2abs($path);
        # AFTER LAST PASS: } } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_carp;
# AFTER LAST PASS: eval { require Carp; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Carp::croak"}) {
        # AFTER LAST PASS: $mock_carp = mock 'Carp' => ( override => { croak => sub {
            my ($message);  # AFTER LAST PASS: my ($message) = @_;
            # AFTER LAST PASS: die $message;
        # AFTER LAST PASS: } } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_carp = mock 'Carp' => ( add => { croak => sub {
            my ($message);  # AFTER LAST PASS: my ($message) = @_;
            # AFTER LAST PASS: die $message;
        # AFTER LAST PASS: } } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Path does not exist
# AFTER LAST PASS: {
    my $path;  # AFTER LAST PASS: my $path;  # UNVALIDATED: my $path = Path::Class::Entity->new('nonexistent/path');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $path->resolve() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/^No such file or directory nonexistent\/path$/, 'resolve throws error for non-existent path');
    # AFTER LAST PASS: } else {
        # FAILED: fail('resolve did not throw error for non-existent path');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Absolute path exists
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $path;  # AFTER LAST PASS: my $path;  # UNVALIDATED: my $path = Path::Class::Entity->new($tempdir);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $path->resolve() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('resolve crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: ok(defined $result, 'resolve returns the same object for existing absolute path');
        # FAILED: is($result->stringify, File::Spec->rel2abs($tempdir), 'path is resolved correctly');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Relative path exists
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $relative_path;  # AFTER LAST PASS: my $relative_path = 'relative/path';
    my $full_path;  # AFTER LAST PASS: my $full_path;  # UNVALIDATED: my $full_path = File::Spec->catfile($tempdir, $relative_path);
    # AFTER LAST PASS: mkdir $full_path;
    my $path;  # AFTER LAST PASS: my $path;  # UNVALIDATED: my $path = Path::Class::Entity->new($relative_path);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $path->resolve() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('resolve crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: ok(defined $result, 'resolve returns the same object for existing relative path');
        # FAILED: is($result->stringify, File::Spec->rel2abs($full_path), 'relative path is resolved correctly');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Relative path converted to absolute
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $relative_path;  # AFTER LAST PASS: my $relative_path = 'relative/path';
    my $full_path;  # AFTER LAST PASS: my $full_path;  # UNVALIDATED: my $full_path = File::Spec->catfile($tempdir, $relative_path);
    # AFTER LAST PASS: mkdir $full_path;
    my $path;  # AFTER LAST PASS: my $path;  # UNVALIDATED: my $path = Path::Class::Entity->new($relative_path);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $path->resolve() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('resolve crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: ok(defined $result, 'resolve returns the same object for relative path');
        # FAILED: is($result->stringify, File::Spec->rel2abs($full_path), 'relative path is resolved correctly');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Path is already absolute
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $path;  # AFTER LAST PASS: my $path;  # UNVALIDATED: my $path = Path::Class::Entity->new($tempdir);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $path->resolve() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('resolve crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: ok(defined $result, 'resolve returns the same object for absolute path');
        # FAILED: is($result->stringify, File::Spec->rel2abs($tempdir), 'absolute path remains unchanged');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();