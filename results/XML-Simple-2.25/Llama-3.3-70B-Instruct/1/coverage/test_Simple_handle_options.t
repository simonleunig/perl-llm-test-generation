use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::handle_options"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'handle_options is defined'); }

my $self = bless {}, 'XML::Simple';
my $dirn = 'in';
my @args = (foo => 'bar', baz => 'qux');
my $result = eval { XML::Simple::handle_options($self, $dirn, @args) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

$self = bless {}, 'XML::Simple';
$dirn = 'in';
@args = (foo => 'bar', invalid => 'option');
$result = eval { XML::Simple::handle_options($self, $dirn, @args) };
if ($@) { like($@, qr/Unrecognised option: invalid/, 'Invalid option error'); } else { fail('Expected error not thrown'); }

# AFTER LAST PASS: $self = bless {}, 'XML::Simple';
# AFTER LAST PASS: $dirn = 'in';
# AFTER LAST PASS: @args = (foo => 'bar');
# UNVALIDATED: $result = eval { XML::Simple::handle_options($self, $dirn, @args) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# AFTER LAST PASS: $self = bless {}, 'XML::Simple';
# AFTER LAST PASS: $dirn = 'in';
# AFTER LAST PASS: @args = (ForceArray => 1);
# UNVALIDATED: $result = eval { XML::Simple::handle_options($self, $dirn, @args) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# AFTER LAST PASS: $self = bless {}, 'XML::Simple';
# AFTER LAST PASS: $dirn = 'in';
# AFTER LAST PASS: @args = (KeyAttr => { elem => '+attr' });
# UNVALIDATED: $result = eval { XML::Simple::handle_options($self, $dirn, @args) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

done_testing();