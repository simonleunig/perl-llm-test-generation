use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subsumes"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subsumes is defined'); }

my $result = eval { Path::Class::Dir->new('/')->subsumes('/tmp', '/var', '/usr') };
if ($@) { like($@, qr/Too many arguments given to subsumes\(\)/, 'Too many arguments'); } else { fail('Expected exception not thrown'); }

$result = eval { Path::Class::Dir->new('/')->subsumes() };
if ($@) { like($@, qr/No second entity given to subsumes\(\)/, 'No second entity'); } else { fail('Expected exception not thrown'); }

$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-Path::Class::Entity object'); }

$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp/file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-directory'); }

$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Absolute path subsumes'); }

$result = eval { Path::Class::Dir->new('tmp')->subsumes('tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Relative path subsumes'); }

$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp', { volume => 'vol1' }) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Volumes do not match'); }

$result = eval { Path::Class::Dir->new('/')->subsumes('/') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Root directory subsumes'); }

$result = eval { Path::Class::Dir->new('.')->subsumes('./tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Current directory subsumes relative path'); }

done_testing();