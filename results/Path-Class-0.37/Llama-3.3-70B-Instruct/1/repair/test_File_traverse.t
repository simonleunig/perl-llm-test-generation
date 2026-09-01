use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

my $file = Path::Class::File->new('test.txt');

my $result = eval { $file->traverse(sub { 'callback result' }, 'arg1', 'arg2') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'callback result', 'Valid callback returns result'); }

my $error = eval { $file->traverse('invalid_callback', 'arg1', 'arg2') };
if ($@) { like($@, qr/Can't locate object method/, 'Invalid callback throws error'); } else { fail('Invalid callback did not throw error'); }

$error = eval { $file->traverse(sub { die 'callback exception' }, 'arg1', 'arg2') };
if ($@) { like($@, qr/callback exception/, 'Callback exception is propagated'); } else { fail('Callback exception was not propagated'); }

done_testing();