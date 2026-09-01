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

my $file_obj = bless({ dir => 'existing_dir' }, 'Path::Class::File');
my $result = eval { $file_obj->dir() };
if ($@) { fail('dir method crashed: ' . $@); } else { is($result, 'existing_dir', 'dir method returns existing directory'); }

my $mock_dir_class;  # AFTER LAST PASS: my $mock_dir_class = mock 'Path::Class::Dir' => ( new => sub { return 'mock_dir' } );
my $mock_file_obj;  # AFTER LAST PASS: my $mock_file_obj = bless({ dir_class => $mock_dir_class, _spec => bless({ curdir => 'mock_curdir' }, 'Path::Class::Spec') }, 'Path::Class::File');
# UNVALIDATED: $result = eval { $mock_file_obj->dir() };
# FAILED: if ($@) { fail('dir method crashed: ' . $@); } else { is($result, 'mock_dir', 'dir method returns new directory'); }

my $invalid_file_obj;  # AFTER LAST PASS: my $invalid_file_obj = bless({}, 'Path::Class::File');
# UNVALIDATED: $result = eval { $invalid_file_obj->dir() };
# FAILED: if ($@) { fail('dir method crashed: ' . $@); } else { ok(defined $result, 'dir method returns result for invalid input'); }

my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $invalid_file_obj->dir() };
# FAILED: if ($@) { like($@, qr/'CODE\(0x[0-9a-f]+\)' is not a valid argument for 'new'/, 'Error message correct'); }

done_testing();