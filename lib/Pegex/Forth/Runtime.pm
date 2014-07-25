package Pegex::Forth::Runtime;
use Pegex::Base;
use Capture::Tiny ':all';

has stack => [];
has return_stack => [];

sub call {
    my ($self, $word) = @_;
    my $function = $self->dict->{lc $word}
        or die "Undefined word: '$word'\n";
    $function->($self);
}

sub size {
    scalar(@{$_[0]->{stack}});
}

sub push {
    my ($self, @items) = @_;
    push @{$self->stack}, @items;
}

sub pop {
    my ($self, $count) = (@_);
    my $stack = $self->{stack};
    $self->underflow unless $count <= @$stack;
    return splice(@$stack, 0 - $count, $count);
}

sub peek {
    my $self = shift;
    my $stack = $self->{stack};
    map {
        my $i = $_ + 1;
        $self->underflow unless $i <= @$stack;
        my $a = $stack->[0 - $i];
        return $a unless wantarray;
    } @_;
}

sub underflow {
    die "Stack underflow\n";
}

has dict => {

'.' => sub {
    my $num = $_[0]->pop(1);
    print "$num\n";
},

'.s' => sub {
    my $stack = $_[0]->stack;
    my $size = @$stack;
    print "<$size>" . join('', map " $_", @$stack) . "\n";
},

'+' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a + $b);
},

'-' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a - $b);
},

'*' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a * $b);
},

'/' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push(int($a / $b));
},

'0sp' => sub {
    $_[0]->{stack} = [];
},

'dup' => sub {
    my ($a) = $_[0]->pop(1);
    $_[0]->push($a, $a);
},

'swap' => sub {
    $_[0]->push(reverse $_[0]->pop(2));
},

'over' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a, $b, $a);
},

'drop' => sub {
    $_[0]->pop(1);
},

'rot' => sub {
    my ($a, $b, $c) = $_[0]->pop(3);
    $_[0]->push($b, $c, $a);
},

'pick' => sub {
    $_[0]->push(scalar $_[0]->peek($_[0]->pop(1)));
},

'?dup' => sub {
    $_[0]->call('dup') if ($_[0]->peek(0) != 0);
},

'-rot' => sub {
    my ($a, $b, $c) = $_[0]->pop(3);
    $_[0]->push($c, $a, $b);
},

'2swap' => sub {
    my ($a, $b, $c, $d) = $_[0]->pop(4);
    $_[0]->push($c, $d, $a, $b);
},

'2over' => sub {
    my ($a, $b, $c, $d) = $_[0]->pop(4);
    $_[0]->push($a, $b, $c, $d, $a, $b);
},

'2dup' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a, $b, $a, $b);
},

'nip' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($b);
},

'tuck' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($b, $a, $b);
},

'abs' => sub {
    $_[0]->push(abs $_[0]->pop(1));
},

'negate' => sub {
    $_[0]->push(0 - $_[0]->pop(1));
},

'lshift' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a << $b);
},

'rshift' => sub {
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a >> $b);
},

'arshift' => sub {
    use integer;
    my ($a, $b) = $_[0]->pop(2);
    $_[0]->push($a >> $b);
},

'emit' => sub {
    print chr $_[0]->pop(1);
},

};

1
