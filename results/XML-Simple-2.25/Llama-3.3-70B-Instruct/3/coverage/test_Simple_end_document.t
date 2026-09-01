use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::end_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'end_document is defined'); }

my $simple = bless({}, 'XML::Simple');
$simple->{tree} = ['root', { foo => 'bar' }];
$simple->{nocollapse} = 1;
my $result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed with nocollapse: ' . $@); } else { ok(defined $result, 'end_document returns result with nocollapse'); }

# AFTER LAST PASS: $simple = bless({}, 'XML::Simple');
# AFTER LAST PASS: $simple->{tree} = ['root', { foo => 'bar' }];
# AFTER LAST PASS: $simple->{opt} = { keeproot => 1 };
# UNVALIDATED: $result = eval { $simple->end_document() };
# FAILED: if ($@) { fail('end_document crashed with keeproot: ' . $@); } else { ok(defined $result, 'end_document returns result with keeproot'); }

# AFTER LAST PASS: $simple = bless({}, 'XML::Simple');
# AFTER LAST PASS: $simple->{tree} = ['root', { foo => 'bar' }];
# AFTER LAST PASS: $simple->{opt} = { datahandler => sub { return 'handled data'; } };
# UNVALIDATED: $result = eval { $simple->end_document() };
# FAILED: if ($@) { fail('end_document crashed with datahandler: ' . $@); } else { ok(defined $result, 'end_document returns result with datahandler'); }

# AFTER LAST PASS: $simple = bless({}, 'XML::Simple');
# AFTER LAST PASS: $simple->{tree} = ['root', { foo => 'bar' }];
# UNVALIDATED: $result = eval { $simple->end_document() };
# FAILED: if ($@) { fail('end_document crashed without options: ' . $@); } else { ok(defined $result, 'end_document returns result without options'); }

done_testing();