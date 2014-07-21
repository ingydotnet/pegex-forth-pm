package Pegex::Forth;
our $VERSION = '0.01';

use Pegex::Parser;

sub run {
    my (@args) = @_;
    my $input = do { local $/; <> };
    my $parser = Pegex::Parser->new(
        grammar => Pegex::Forth::Grammar->new,
        receiver => Pegex::Forth::Exec->new,
        # debug => 1,
    );
    $parser->parse($input);
}

{
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
}

{
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
        my ($self, $item) = @_;
        push @{$self->stack}, $item;
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
}

1;
