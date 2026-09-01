use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::_spec_class"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_spec_class is defined'); }

my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Unix') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'File::Spec::Unix', 'Returns correct File::Spec module for Unix');
}

$result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Win32') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'File::Spec::Win32', 'Returns correct File::Spec module for Win32');
}

$result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', '') };
if ($@) {
    like($@, qr/Invalid system type ''/, 'Dies with correct message for empty system type');
} else {
    # FAILED: fail('Function did not die for empty system type');
}

# UNVALIDATED: $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Unix!@#') };
# AFTER LAST PASS: if ($@) {
    # FAILED: like($@, qr/Invalid system type 'Unix!@#'/, 'Dies with correct message for invalid system type');
# AFTER LAST PASS: } else {
    # FAILED: fail('Function did not die for invalid system type');
# AFTER LAST PASS: }

my $mock;
# AFTER LAST PASS: eval { require File::Spec::NonExistent; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Spec::NonExistent - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Spec::NonExistent::method"}) {
        # AFTER LAST PASS: $mock = mock 'File::Spec::NonExistent' => ( override => [ 'method' => sub { die 'Module not found' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'File::Spec::NonExistent' => ( add => [ 'method' => sub { die 'Module not found' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# UNVALIDATED: $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'NonExistent') };
# AFTER LAST PASS: if ($@) {
    # FAILED: like($@, qr/Module not found/, 'Dies with correct message for non-existent File::Spec module');
# AFTER LAST PASS: } else {
    # FAILED: fail('Function did not die for non-existent File::Spec module');
# AFTER LAST PASS: }

done_testing();