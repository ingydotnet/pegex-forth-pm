package Pegex::Forth::Runtime;
use Pegex::Base;

has stack => [];

sub call {
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

has dict => {

'.' => sub {
    my ($self) = @_;
    my $num = $self->pop;
    print "$num\n";
},

'+' => sub {
    my ($self) = @_;
    my ($a, $b) = $self->pop(2);
    $self->push($a + $b);
},

'-' => sub {
    my ($self) = @_;
    my ($a, $b) = $self->pop(2);
    $self->push($a - $b);
},

};

1
