package TestPegexForth;
use Test::More();
use Pegex::Forth;

use base 'Exporter';
@EXPORT = qw(test);

sub test {
    my ($forth, $want, $label) = @_;
    my $got = Pegex::Forth->new->run($forth);
    Test::More::is $got, $want, $label;
}

1;
