package Pegex::Forth;
our $VERSION = '0.02';

use Pegex::Base;
use Pegex::Parser;

has 'args' => [];

sub command {
    my ($self) = @_;
    my $args = $self->args;
    my $input;
    if (@$args) {
        if (-f $args->[0]) {
            open my $fh, $args->[0] or die;
            $input = do { local $/; <$fh> };
        }
        else {
            die "Unknown args";
        }
    }
    else {
        $input = do { local $/; <> };
    }
    $self->run($input);
}

sub run {
    my ($self, $input) = @_;
    my $runtime = Pegex::Forth::Exec->new;
    my $parser = Pegex::Parser->new(
        grammar => Pegex::Forth::Grammar->new,
        receiver => $runtime,
        # debug => 1,
    );
    $parser->parse($input);
    my $values = $runtime->stack;
    return unless @$values;
    wantarray ? @$values : $values->[-1];
}



package Pegex::Forth::Grammar;
use Pegex::Base;
extends 'Pegex::Grammar';
use constant text => <<'...';
forth: token*

token:
  | number
  | word

number: /- ( DIGIT+ ) +/
word: /- ( NS+ ) +/

ws: / (: WS | EOS ) /
...

package Pegex::Forth::Exec;
use Pegex::Base;
extends 'Pegex::Tree';

has stack => [];
my $dict = {};
has dict => sub { +{ %$dict } };

sub got_number {
    my ($self, $number) = @_;
    $self->push($number);
}

sub got_word {
    my ($self, $word) = @_;
    my $function = $self->dict->{$word}
        or die "Undefined word '$word'\n";
    $function->($self);
}

sub push {
    my ($self, @items) = @_;
    push @{$self->stack}, @items;
}

sub pop {
    my ($self, $count) = (@_, 1);
    my $stack = $self->stack;
    die "Stack underflow\n" unless @$stack >= $count;
    return splice(@$stack, 0 - $count, $count);
}

$dict->{'.'} = sub {
    my ($self) = @_;
    my $num = $self->pop;
    print "$num\n";
};

$dict->{'+'} = sub {
    my ($self) = @_;
    my ($a, $b) = $self->pop(2);
    $self->push($a + $b);
};

$dict->{'-'} = sub {
    my ($self) = @_;
    my ($a, $b) = $self->pop(2);
    $self->push($a - $b);
};

1;
