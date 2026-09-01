use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse_if"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'traverse_if is defined'); }

my $result = eval { Path::Class::File->new()->traverse_if(sub { 'result' }, sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail("traverse_if crashed: $@"); } else { ok(defined $result, 'traverse_if returns a result'); }
is($result, 'result', 'traverse_if returns the correct result');

my $invalid_callback_result = eval { Path::Class::File->new()->traverse_if('invalid_callback', sub { 1 }, 'arg1', 'arg2') };
if ($@) { like($@, qr/Can't locate object method/, 'traverse_if handles invalid callback'); } else { fail('traverse_if did not handle invalid callback'); }

my $invalid_condition_result = eval { Path::Class::File->new()->traverse_if(sub { 'result' }, 'invalid_condition', 'arg1', 'arg2') };
if ($@) { like($@, qr/Type of argument/, 'traverse_if handles invalid condition'); } else { fail('traverse_if did not handle invalid condition'); }

my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::dir"}) {
        $mock = mock 'Path::Class::Dir' => ( override => [ dir => sub { 'mocked_dir' } ] );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => [ dir => sub { 'mocked_dir' } ] );
    }
}

done_testing();