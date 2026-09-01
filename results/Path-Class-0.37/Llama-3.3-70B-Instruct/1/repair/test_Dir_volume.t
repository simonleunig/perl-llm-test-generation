use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

my $dir = Path::Class::Dir->new('/tmp');
my $result = eval { $dir->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid directory'); }

my $invalid_dir = bless {}, 'Path::Class::Dir';
my $invalid_result = eval { $invalid_dir->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $invalid_result, 'Function returns undefined for invalid directory'); }

my $relative_dir = Path::Class::Dir->new('relative/path');
my $relative_result = eval { $relative_dir->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $relative_result, 'Function returns undefined for relative path'); }

my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock = mock 'Path::Class::Entity' => ( override => [ new => sub { bless {}, 'Path::Class::Entity' } ] );
    } else {
        $mock = mock 'Path::Class::Entity' => ( add => [ new => sub { bless {}, 'Path::Class::Entity' } ] );
    }
}

done_testing();