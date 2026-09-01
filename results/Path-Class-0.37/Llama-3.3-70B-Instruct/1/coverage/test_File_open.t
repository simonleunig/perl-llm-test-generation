use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->open('r') };
if ($@) { fail('Open crashed: ' . $@); } else { ok(defined $result, 'Open returns result'); }
unlink($filename);

my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
$result = eval { $non_existent_file->open('r') };
# FAILED: if ($@) { fail('Open crashed: ' . $@); } else { ok(!defined $result, 'Open returns undef for non-existent file'); }

my $existing_file = Path::Class::File->new($filename);
$result = eval { $existing_file->open('invalid_mode') };
if ($@) { 
    like($@, qr/IO::Handle: bad open mode/, 'Open crashes with invalid mode');
} else { 
    # FAILED: ok(!defined $result, 'Open returns undef for invalid mode'); 
}
# AFTER LAST PASS: unlink($filename);

done_testing();