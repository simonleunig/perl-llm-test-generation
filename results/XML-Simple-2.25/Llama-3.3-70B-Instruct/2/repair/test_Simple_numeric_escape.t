use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::numeric_escape"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'numeric_escape is defined'); }

my $result1 = eval { XML::Simple->new()->numeric_escape("Hello, Sérgio!", 2) };
if ($@) { fail('numeric_escape crashed: ' . $@); } else { ok(defined $result1, 'numeric_escape returns result with level 2'); }
is($result1, "Hello, S&#233;rgio!", 'numeric_escape with level 2 works correctly');

my $result2 = eval { XML::Simple->new()->numeric_escape("Hello, Sérgio!", 1) };
if ($@) { fail('numeric_escape crashed: ' . $@); } else { ok(defined $result2, 'numeric_escape returns result with level 1'); }
is($result2, "Hello, S&#233;rgio!", 'numeric_escape with level 1 works correctly');

my $result3 = eval { XML::Simple->new()->numeric_escape(undef, 2) };
if ($@) { fail('numeric_escape crashed: ' . $@); } else { ok(defined $result3, 'numeric_escape returns result with undefined input'); }
is($result3, '', 'numeric_escape with undefined input works correctly');

my $result4 = eval { XML::Simple->new()->numeric_escape("Hello, Sérgio!", 2) };
if ($@) { fail('numeric_escape crashed: ' . $@); } else { ok(defined $result4, 'numeric_escape returns result with level 2 and non-ASCII characters above 0x7F'); }
is($result4, "Hello, S&#233;rgio!", 'numeric_escape with level 2 and non-ASCII characters above 0x7F works correctly');

done_testing();