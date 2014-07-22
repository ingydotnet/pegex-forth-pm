use File::Basename; use lib dirname(__FILE__); use TestPegexForth;

my $forth;

test_out '3 4 .s', "<2> 3 4", '.s works';
