use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::die_or_warn"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'die_or_warn is defined'); }

my $mock_obj = bless { opt => { strictmode => 1 } }, 'XML::Simple';
my $result = eval { $mock_obj->die_or_warn('Test error message') };
if ($@) { 
    like($@, qr/Test error message/, 'die_or_warn dies with error message when strictmode is enabled'); 
} else { 
    fail('die_or_warn did not die when strictmode is enabled'); 
}

$mock_obj = bless { opt => { strictmode => 0 } }, 'XML::Simple';
my $warn_mock;
eval { require warnings; };
if ($@) {
    # DEPENDENCY MISSING: warnings - mock skipped
} else {
    no strict 'refs';
    if (defined &{"warnings::enabled"}) {
        $warn_mock = mock 'warnings' => ( override => [ enabled => sub { return 1 } ] );
    } else {
        $warn_mock = mock 'warnings' => ( add => [ enabled => sub { return 1 } ] );
    }
}
my $carp_mock;
eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::carp"}) {
        $carp_mock = mock 'Carp' => ( override => [ carp => sub { fail('Warning: Test error message') } ] );
    } else {
        $carp_mock = mock 'Carp' => ( add => [ carp => sub { fail('Warning: Test error message') } ] );
    }
}
$result = eval { $mock_obj->die_or_warn('Test error message') };
if ($@) { 
    fail('die_or_warn crashed when strictmode is disabled and warnings are enabled'); 
} else { 
    pass('die_or_warn issued a warning when strictmode is disabled and warnings are enabled'); 
}

$mock_obj = bless { opt => { strictmode => 0 } }, 'XML::Simple';
$warn_mock;
eval { require warnings; };
if ($@) {
    # DEPENDENCY MISSING: warnings - mock skipped
} else {
    no strict 'refs';
    if (defined &{"warnings::enabled"}) {
        $warn_mock = mock 'warnings' => ( override => [ enabled => sub { return 0 } ] );
    } else {
        $warn_mock = mock 'warnings' => ( add => [ enabled => sub { return 0 } ] );
    }
}
$result = eval { $mock_obj->die_or_warn('Test error message') };
if ($@) { 
    fail('die_or_warn crashed when strictmode is disabled and warnings are disabled'); 
} else { 
    pass('die_or_warn silently ignored the error message when strictmode is disabled and warnings are disabled'); 
}

done_testing();