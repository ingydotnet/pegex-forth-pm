use File::Basename; use lib dirname(__FILE__); use TestPegexForth;

my $forth;

test_out '3 4 .', "4", '. works';
test_out '3 4 .s', "<2> 3 4", '.s works';
test_stack '3 4 +', '[7]', '+ works';
test_stack '3 4 -', '[-1]', '- works';
test_stack '3 4 0sp', '[]', '0sp works';
test_stack '3 4 dup', '[3,4,4]', 'dup works';
test_stack '3 4 swap', '[4,3]', 'dup works';
test_stack '3 4 over', '[3,4,3]', 'dup works';
test_stack '3 4 drop', '[3]', 'dup works';
test_stack '3 4 5 rot', '[4,5,3]', 'dup works';
