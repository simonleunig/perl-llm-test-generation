use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::next"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'next is defined'); }

my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result, 'next returns result'); }

my $mock_dir;
# UNVALIDATED: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::open"}) {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => ( override => [ open => sub { return undef } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir = mock 'Path::Class::Dir' => ( add => [ open => sub { return undef } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $mock_dir->next() };
# FAILED: if ($@) { like($@, qr/Can't open directory/, 'next throws exception when directory cannot be opened'); } else { fail('next did not throw exception'); }

my $mock_dh;
# UNVALIDATED: eval { require IO::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"IO::Dir::read"}) {
        # AFTER LAST PASS: $mock_dh = mock 'IO::Dir' => ( override => [ read => sub { return undef } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dh = mock 'IO::Dir' => ( add => [ read => sub { return undef } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
my $mock_dir_with_dh;
# UNVALIDATED: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::open"}) {
        # AFTER LAST PASS: $mock_dir_with_dh = mock 'Path::Class::Dir' => ( override => [ open => sub { return $mock_dh } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir_with_dh = mock 'Path::Class::Dir' => ( add => [ open => sub { return $mock_dh } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $mock_dir_with_dh->next() };
# FAILED: if ($@) { fail('next crashed: ' . $@); } else { ok(!defined $result, 'next returns undef when end of directory is reached'); }

my $mock_file;
# UNVALIDATED: eval { require Path::Class::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::File::new"}) {
        # AFTER LAST PASS: $mock_file = mock 'Path::Class::File' => ( override => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_file = mock 'Path::Class::File' => ( add => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
my $mock_dir_with_file;
# UNVALIDATED: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::open"}) {
        # AFTER LAST PASS: $mock_dir_with_file = mock 'Path::Class::Dir' => ( override => [ open => sub { return $mock_dh }, file => sub { return $mock_file } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir_with_file = mock 'Path::Class::Dir' => ( add => [ open => sub { return $mock_dh }, file => sub { return $mock_file } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $mock_dir_with_file->next() };
# FAILED: if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result && ref($result) eq 'Path::Class::File', 'next returns file object when entry is a file'); }

my $mock_subdir;
# UNVALIDATED: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::new"}) {
        # AFTER LAST PASS: $mock_subdir = mock 'Path::Class::Dir' => ( override => [ new => sub { return bless {}, 'Path::Class::Dir' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_subdir = mock 'Path::Class::Dir' => ( add => [ new => sub { return bless {}, 'Path::Class::Dir' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
my $mock_dir_with_subdir;
# UNVALIDATED: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::open"}) {
        # AFTER LAST PASS: $mock_dir_with_subdir = mock 'Path::Class::Dir' => ( override => [ open => sub { return $mock_dh }, subdir => sub { return $mock_subdir } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_dir_with_subdir = mock 'Path::Class::Dir' => ( add => [ open => sub { return $mock_dh }, subdir => sub { return $mock_subdir } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $mock_dir_with_subdir->next() };
# FAILED: if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result && ref($result) eq 'Path::Class::Dir', 'next returns dir object when entry is a directory'); }

done_testing();