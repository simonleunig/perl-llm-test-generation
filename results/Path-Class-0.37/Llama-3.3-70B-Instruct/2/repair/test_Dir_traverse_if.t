use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

my $callback = sub {
    my ($self, $sub) = @_;
    return $sub->();
};

my $condition = sub {
    my ($file) = @_;
    return 1;  
};

my $result = eval { $dir->traverse_if($callback, $condition) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns result'); }

my $invalid_dir = Path::Class::Dir->new('/non/existent/directory');
$result = eval { $invalid_dir->traverse_if($callback, $condition) };
if ($@) { 
    like($@, qr/No such file or directory/, 'traverse_if dies with invalid directory');
} else { 
    fail('traverse_if did not die with invalid directory');
}

my $false_condition = sub {
    my ($file) = @_;
    return 0;  
};
$result = eval { $dir->traverse_if($callback, $false_condition) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns result when condition is always false'); }

done_testing();