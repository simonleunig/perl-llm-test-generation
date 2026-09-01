use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

my $file = bless { dir => Path::Class::Dir->new('test_dir') }, 'Path::Class::File';
my $result = eval { $file->dir };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns result when defined'); }
is(ref($result), 'Path::Class::Dir', 'dir returns Path::Class::Dir object when defined');

my $file_undef = bless { }, 'Path::Class::File';
my $mock;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::dir_class"}) {
        $mock = mock 'Path::Class::File' => ( override => {
            dir_class => sub { return 'Path::Class::Dir'; },
            _spec     => sub { return bless { curdir => '/' }, 'Path::Class::Spec'; },
        });
    } else {
        $mock = mock 'Path::Class::File' => ( add => {
            dir_class => sub { return 'Path::Class::Dir'; },
            _spec     => sub { return bless { curdir => '/' }, 'Path::Class::Spec'; },
        });
    }
}
$result = eval { $file_undef->dir };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns result when not defined'); }
is(ref($result), 'Path::Class::Dir', 'dir returns Path::Class::Dir object when not defined');

done_testing();