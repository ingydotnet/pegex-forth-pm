package Pegex::Forth::Runtime;
use Pegex::Base;
use Capture::Tiny ':all';

has stack => [];
has return_stack => [];

sub call {
    my ($self, $word) = @_;
    my $function = $self->dict->{$word}
        or die "Undefined word: '$word'\n";
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

'.s' => sub {
    my ($self) = @_;
    my $stack = $self->stack;
    my $size = @$stack;
    print "<$size>" . join('', map " $_", @$stack) . "\n";
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

'0sp' => sub {
    my ($self) = @_;
    $self->{stack} = [];
},

dup => sub {
    my ($self) = @_;
    my ($a) = $self->pop(1);
    $self->push($a, $a);
},

swap => sub {
    my ($self) = @_;
    my ($a, $b) = $self->pop(2);
    $self->push($b, $a);
},

over => sub {
    my ($self) = @_;
    my ($a, $b) = $self->pop(2);
    $self->push($a, $b, $a);
},

drop => sub {
    my ($self) = @_;
    my ($a) = $self->pop(1);
},

rot => sub {
    my ($self) = @_;
    my ($a, $b, $c) = $self->pop(3);
    $self->push($b, $c, $a);
},

};

1
