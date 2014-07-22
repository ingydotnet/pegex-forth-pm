use strict;
use File::Basename;
use lib dirname(__FILE__);
use TestPegexForth;

use Test::More;

my $forth = "
3 ( Put 3 on stack )
4 ( Put 4 on stack )
+ ( Add top 2 stack elems and put result on stack )
( . ) ( Take last entry off stack and print it )
";
test $forth, 7, 'Comments work';

done_testing;
