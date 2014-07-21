use Test::More;
use Pegex::Forth;
use Capture::Tiny ':all';

my ($out) = capture {
    Pegex::Forth->new->run('3 4 + .');
};
chomp $out;
is $out, 7, 'Printed result is 7';

is 'Pegex::Forth'->new->run('3 4 +'), 7, 'run() returns number';
is 'Pegex::Forth'->new->run('3 4 -'), -1, 'Subtraction works';

done_testing;
