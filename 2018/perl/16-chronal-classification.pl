
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(natatime pairmap);
use Data::Dump qw(dd pp);
use Sub::Quote qw(quote_sub);
use experimental 'smartmatch';

my %inst = build_instructions(
    addr => "ra + rb",
    addi => "ra + b",
    mulr => "ra * rb",
    muli => "ra * b",
    banr => "ra & rb",
    bani => "ra & b",
    borr => "ra | rb",
    bori => "ra | b",
    setr => "ra",
    seti => " a",
    gtir => " a >  rb ? 1 : 0",
    gtri => "ra >  b  ? 1 : 0",
    gtrr => "ra >  rb ? 1 : 0",
    eqir => " a == rb ? 1 : 0",
    eqri => "ra == b  ? 1 : 0",
    eqrr => "ra == rb ? 1 : 0",
);


my @opcodes = qw(
    eqir
    borr
    addr
    gtri
    muli
    gtir
    mulr
    banr
    bori
    eqri
    eqrr
    bani
    setr
    gtrr
    addi
    seti
);


dd sample_match_opcodes([3, 2, 1, 1], [9, 2, 1, 2], [3, 2, 2, 1]);

my $input_file = "../input/16.txt";
my @input = file($input_file)->slurp(chomp => 1);
my $three = natatime 4, @input;
my $count = 0;
my %histogram = ();
while(my @items = $three->()) {
    last if $items[0] eq '';
    my $before = [ $items[0] =~ /\d+/g ];
    my $op     = [ $items[1] =~ /\d+/g ];
    my $after  = [ $items[2] =~ /\d+/g ];
    my @matches = sample_match_opcodes($before, $op, $after);

    $histogram{ scalar @matches }{ join ', ', @matches }{ $op->[0] }++;
    $count++ if @matches >= 3;

    # record instruction
    if(@matches == 1) {
        $opcodes[$op->[0]] = $matches[0];
    }
}
is $count, 614, 'part 1';

# dd \%histogram;
# dd \@opcodes;

my $registers = [0,0,0,0];
while(<DATA>) {
    my @line = /\d+/g;
    $registers = $inst{ $opcodes[ $line[0] ] }->(@line[1..3], $registers);
}
dd $registers;


done_testing;


sub sample_match_opcodes {
    my ($before, $inst, $after) = @_;

    my %ops = ();
    while(my ($code, $op) = each %inst) {
        my $regs = $op->($inst->[1], $inst->[2], $inst->[3], $before);
        $ops{ $code }++ if $regs ~~ $after;
    }

    return keys %ops;
}

sub build_instructions {
    return pairmap {
        my $code = $b;
        $code =~ s/\b([ab])\b/\$$1/g;
        $code =~ s/\br([ab])\b/\$r->[\$$1]/g;
        $a => quote_sub q{ my ($a, $b, $c, $r) = @_; my $res = eval pp $r; $res->[$c] = } . $code . q{ ; return $res };
    } @_;
}

__DATA__
15 1 2 1
4 0 0 0
14 0 3 0
15 0 0 2
11 0 2 1
4 1 1 1
4 1 3 1
2 3 1 3
15 3 0 1
15 2 2 0
3 0 1 1
4 1 2 1
2 3 1 3
15 0 2 1
15 3 0 2
1 0 2 0
4 0 3 0
2 0 3 3
12 3 3 2
4 3 0 0
14 0 2 0
15 2 1 1
4 2 0 3
14 3 2 3
10 0 3 3
4 3 2 3
2 2 3 2
12 2 2 3
15 3 3 1
15 0 3 0
15 3 0 2
11 1 2 1
4 1 2 1
4 1 3 1
2 3 1 3
12 3 3 1
15 1 0 3
15 2 2 0
15 1 3 2
13 0 3 3
4 3 3 3
2 3 1 1
12 1 0 2
15 3 3 1
4 0 0 0
14 0 1 0
15 2 1 3
6 0 3 3
4 3 3 3
4 3 3 3
2 2 3 2
12 2 3 1
15 2 1 3
15 0 2 2
4 2 0 0
14 0 2 0
10 0 3 0
4 0 3 0
4 0 2 0
2 1 0 1
12 1 3 3
15 3 2 2
4 0 0 0
14 0 2 0
15 1 2 1
1 0 2 0
4 0 1 0
2 3 0 3
12 3 1 1
15 2 2 3
4 1 0 0
14 0 2 0
15 2 2 2
10 0 3 0
4 0 3 0
2 0 1 1
4 1 0 2
14 2 3 2
15 0 2 3
15 2 2 0
0 3 2 0
4 0 2 0
2 1 0 1
12 1 3 0
15 2 0 2
15 3 3 3
15 3 3 1
3 2 1 1
4 1 2 1
4 1 1 1
2 1 0 0
4 2 0 1
14 1 0 1
4 1 0 3
14 3 0 3
5 3 2 3
4 3 1 3
2 0 3 0
15 2 2 3
15 1 0 1
8 2 3 3
4 3 1 3
2 3 0 0
12 0 0 1
15 3 2 2
4 2 0 0
14 0 3 0
4 0 0 3
14 3 3 3
11 3 2 2
4 2 2 2
2 1 2 1
12 1 0 0
15 2 3 3
15 2 1 1
15 2 3 2
8 1 3 1
4 1 2 1
2 0 1 0
12 0 2 2
15 2 3 0
4 2 0 3
14 3 1 3
15 3 2 1
3 0 1 0
4 0 1 0
2 2 0 2
12 2 2 3
15 0 0 2
15 1 1 0
2 0 0 2
4 2 3 2
2 2 3 3
15 0 1 0
15 3 2 2
11 1 2 2
4 2 3 2
2 3 2 3
15 2 0 2
4 1 0 1
14 1 0 1
15 1 3 0
12 0 2 2
4 2 1 2
2 2 3 3
12 3 1 2
15 2 3 1
15 2 1 3
4 2 0 0
14 0 2 0
10 0 3 1
4 1 1 1
4 1 2 1
2 1 2 2
15 3 0 1
15 1 0 3
7 1 0 3
4 3 1 3
2 2 3 2
12 2 3 3
15 1 1 1
15 3 0 0
15 3 0 2
15 2 0 2
4 2 2 2
2 2 3 3
12 3 0 2
15 0 1 1
4 0 0 0
14 0 2 0
4 3 0 3
14 3 0 3
8 0 3 0
4 0 3 0
2 0 2 2
4 1 0 0
14 0 1 0
15 3 3 1
15 2 3 3
14 0 1 0
4 0 1 0
4 0 1 0
2 2 0 2
12 2 3 0
4 0 0 1
14 1 2 1
4 3 0 2
14 2 2 2
15 0 1 3
8 1 3 1
4 1 1 1
4 1 2 1
2 1 0 0
4 0 0 1
14 1 1 1
15 3 3 2
0 3 2 3
4 3 1 3
2 0 3 0
12 0 2 1
15 0 3 2
15 1 0 0
15 2 0 3
0 2 3 2
4 2 1 2
2 1 2 1
12 1 2 2
15 3 0 1
14 0 1 3
4 3 3 3
2 2 3 2
12 2 1 1
15 0 3 3
4 0 0 0
14 0 2 0
15 0 1 2
8 0 3 0
4 0 2 0
2 0 1 1
12 1 2 3
15 3 0 0
15 3 1 1
4 0 0 2
14 2 2 2
3 2 0 0
4 0 3 0
2 3 0 3
4 3 0 1
14 1 2 1
4 2 0 0
14 0 3 0
15 0 3 2
11 0 2 2
4 2 2 2
4 2 3 2
2 2 3 3
12 3 0 2
15 3 1 1
15 1 1 3
15 2 3 0
13 0 3 0
4 0 1 0
4 0 1 0
2 2 0 2
12 2 3 3
4 0 0 0
14 0 1 0
15 2 3 2
4 3 0 1
14 1 0 1
12 0 2 0
4 0 1 0
4 0 1 0
2 0 3 3
12 3 3 1
15 0 0 3
15 3 0 0
5 3 2 0
4 0 3 0
2 1 0 1
15 2 1 0
15 3 1 2
9 0 2 3
4 3 3 3
2 1 3 1
12 1 1 2
15 3 0 1
15 2 2 3
8 0 3 3
4 3 1 3
2 2 3 2
12 2 1 1
15 2 3 2
15 1 0 3
4 1 0 0
14 0 1 0
12 0 2 2
4 2 3 2
2 1 2 1
15 2 2 2
15 0 2 3
15 2 3 0
5 3 2 3
4 3 2 3
2 1 3 1
12 1 3 2
15 3 2 1
15 2 2 3
8 0 3 0
4 0 1 0
4 0 3 0
2 0 2 2
12 2 2 0
15 1 1 3
15 0 2 1
15 2 1 2
2 3 3 1
4 1 2 1
2 0 1 0
12 0 3 2
4 1 0 0
14 0 2 0
4 1 0 3
14 3 2 3
15 2 3 1
10 0 3 0
4 0 3 0
2 0 2 2
12 2 1 3
15 2 1 0
15 3 2 2
15 1 3 1
6 1 0 1
4 1 1 1
4 1 2 1
2 3 1 3
12 3 0 1
15 2 0 3
9 0 2 2
4 2 3 2
4 2 3 2
2 2 1 1
15 0 2 3
15 3 2 2
15 1 2 0
0 3 2 3
4 3 2 3
2 3 1 1
12 1 2 3
15 0 2 1
14 0 1 2
4 2 1 2
2 2 3 3
12 3 1 0
15 2 0 3
15 2 2 2
15 2 2 1
8 1 3 2
4 2 3 2
4 2 3 2
2 0 2 0
15 1 3 3
15 2 1 2
2 3 3 1
4 1 3 1
2 1 0 0
12 0 3 2
15 2 2 3
4 0 0 0
14 0 2 0
4 0 0 1
14 1 0 1
10 0 3 1
4 1 2 1
2 1 2 2
15 3 0 0
15 2 1 1
7 0 3 0
4 0 3 0
2 2 0 2
12 2 1 3
4 2 0 2
14 2 3 2
15 1 0 0
4 0 2 2
4 2 2 2
2 2 3 3
12 3 3 2
15 3 1 1
15 2 0 0
15 2 1 3
10 0 3 3
4 3 3 3
2 3 2 2
12 2 2 3
15 0 3 0
15 1 0 2
11 1 2 0
4 0 2 0
2 3 0 3
12 3 1 2
4 0 0 3
14 3 0 3
15 2 0 0
15 0 3 1
8 0 3 1
4 1 3 1
2 1 2 2
12 2 0 0
15 1 1 2
15 1 3 3
15 3 0 1
2 3 3 1
4 1 2 1
2 0 1 0
12 0 1 2
15 1 1 0
15 2 0 3
15 2 3 1
6 0 3 3
4 3 3 3
2 3 2 2
15 3 1 3
2 0 0 3
4 3 2 3
2 2 3 2
12 2 0 1
15 3 1 2
15 2 0 0
15 1 0 3
9 0 2 3
4 3 1 3
4 3 1 3
2 3 1 1
4 0 0 3
14 3 3 3
15 3 0 0
15 2 1 2
3 2 0 3
4 3 2 3
2 3 1 1
15 3 1 2
4 0 0 3
14 3 3 3
15 1 3 0
11 3 2 2
4 2 2 2
2 2 1 1
15 3 1 2
15 2 1 0
9 0 2 2
4 2 3 2
2 2 1 1
12 1 2 3
15 0 0 2
4 1 0 1
14 1 3 1
15 1 3 0
4 0 2 1
4 1 1 1
2 3 1 3
12 3 0 2
15 3 1 0
15 3 1 3
15 2 0 1
7 0 1 0
4 0 1 0
2 2 0 2
12 2 1 0
15 0 2 1
15 0 0 3
15 3 3 2
0 3 2 2
4 2 2 2
4 2 1 2
2 2 0 0
12 0 0 1
15 3 3 3
15 2 2 2
15 1 1 0
12 0 2 0
4 0 2 0
2 1 0 1
15 3 2 2
15 0 2 3
15 0 1 0
0 3 2 0
4 0 1 0
2 0 1 1
12 1 2 2
15 2 1 3
4 2 0 1
14 1 1 1
15 1 2 0
6 1 3 3
4 3 1 3
2 3 2 2
12 2 2 3
15 0 0 2
4 2 0 0
14 0 3 0
15 0 0 1
15 2 0 0
4 0 3 0
2 0 3 3
12 3 1 2
4 0 0 1
14 1 2 1
15 3 3 0
15 1 0 3
2 3 3 1
4 1 1 1
2 2 1 2
12 2 2 0
15 1 2 2
15 0 2 1
2 3 3 2
4 2 1 2
4 2 2 2
2 2 0 0
12 0 1 3
4 3 0 1
14 1 2 1
15 2 2 2
15 3 1 0
7 0 1 0
4 0 2 0
4 0 2 0
2 0 3 3
12 3 2 1
4 3 0 2
14 2 0 2
15 1 3 0
4 3 0 3
14 3 2 3
6 0 3 3
4 3 1 3
2 1 3 1
12 1 3 2
15 1 2 1
15 2 3 3
6 0 3 1
4 1 2 1
4 1 2 1
2 1 2 2
12 2 1 0
15 0 1 3
4 1 0 2
14 2 2 2
15 3 3 1
3 2 1 3
4 3 3 3
4 3 1 3
2 3 0 0
4 0 0 2
14 2 1 2
15 3 1 3
15 0 3 1
11 3 2 2
4 2 1 2
2 0 2 0
15 2 3 3
15 0 2 2
4 2 0 1
14 1 1 1
0 2 3 2
4 2 1 2
4 2 3 2
2 0 2 0
12 0 2 2
15 3 0 3
15 2 1 0
7 3 0 3
4 3 3 3
4 3 1 3
2 2 3 2
12 2 2 0
15 1 0 3
4 0 0 1
14 1 2 1
4 2 0 2
14 2 3 2
1 1 2 3
4 3 3 3
4 3 2 3
2 3 0 0
12 0 3 3
15 1 3 0
4 3 0 2
14 2 2 2
12 0 2 0
4 0 1 0
4 0 2 0
2 3 0 3
12 3 1 1
15 1 3 3
15 3 0 2
15 2 3 0
1 0 2 0
4 0 1 0
2 1 0 1
15 2 2 0
13 0 3 3
4 3 1 3
4 3 1 3
2 1 3 1
12 1 1 2
15 2 1 3
15 1 3 1
10 0 3 1
4 1 2 1
4 1 3 1
2 2 1 2
15 0 0 3
15 3 0 1
3 0 1 1
4 1 1 1
4 1 1 1
2 2 1 2
12 2 3 1
15 2 3 3
15 2 1 2
8 2 3 3
4 3 2 3
2 3 1 1
12 1 0 2
15 0 2 1
4 1 0 3
14 3 1 3
6 3 0 1
4 1 1 1
4 1 2 1
2 1 2 2
12 2 0 3
15 3 1 0
15 3 0 2
15 2 1 1
1 1 0 2
4 2 3 2
4 2 2 2
2 2 3 3
12 3 1 0
15 3 2 1
15 2 0 3
4 3 0 2
14 2 0 2
0 2 3 3
4 3 3 3
2 3 0 0
15 1 1 2
4 3 0 3
14 3 3 3
15 2 0 1
7 3 1 3
4 3 3 3
4 3 1 3
2 3 0 0
12 0 3 3
4 0 0 1
14 1 0 1
15 0 3 0
15 3 1 2
15 2 0 2
4 2 3 2
2 3 2 3
12 3 2 1
15 0 2 2
15 1 2 3
15 2 2 0
4 3 2 2
4 2 1 2
4 2 1 2
2 1 2 1
12 1 2 2
15 2 0 1
13 0 3 3
4 3 3 3
2 2 3 2
4 1 0 1
14 1 0 1
15 2 2 3
4 2 0 0
14 0 0 0
15 3 0 1
4 1 3 1
2 2 1 2
12 2 0 3
15 2 3 0
15 2 3 1
15 3 1 2
1 1 2 2
4 2 2 2
2 3 2 3
12 3 3 1
15 2 1 2
15 3 0 3
15 1 3 0
12 0 2 3
4 3 3 3
2 3 1 1
15 0 2 3
12 0 2 0
4 0 2 0
2 1 0 1
12 1 0 3
15 0 2 1
15 3 0 0
3 2 0 1
4 1 3 1
4 1 3 1
2 3 1 3
15 0 2 2
15 3 3 1
9 2 0 1
4 1 3 1
2 3 1 3
12 3 2 2
15 0 0 1
4 3 0 3
14 3 2 3
7 0 3 1
4 1 1 1
2 1 2 2
15 2 1 1
15 2 3 0
15 1 0 3
2 3 3 0
4 0 3 0
2 0 2 2
12 2 2 1
15 3 2 2
15 0 1 3
15 3 2 0
15 2 3 3
4 3 2 3
4 3 2 3
2 1 3 1
12 1 1 0
4 1 0 3
14 3 1 3
15 1 3 1
4 1 2 2
4 2 2 2
4 2 1 2
2 2 0 0
12 0 3 2
15 3 0 3
15 2 1 1
15 0 1 0
7 3 1 3
4 3 1 3
4 3 2 3
2 2 3 2
12 2 0 0
15 3 2 2
15 3 3 1
4 3 0 3
14 3 0 3
0 3 2 3
4 3 3 3
2 0 3 0
4 1 0 1
14 1 1 1
4 2 0 2
14 2 1 2
15 2 2 3
6 1 3 3
4 3 3 3
2 0 3 0
12 0 2 1
15 0 3 2
15 2 0 0
15 2 0 3
0 2 3 0
4 0 1 0
2 0 1 1
12 1 1 0
15 1 1 1
0 2 3 1
4 1 2 1
2 1 0 0
4 2 0 1
14 1 2 1
15 2 3 2
15 0 3 3
5 3 2 1
4 1 3 1
2 1 0 0
15 1 1 2
15 0 2 1
15 1 1 3
14 3 1 2
4 2 3 2
2 2 0 0
12 0 0 2
15 3 3 0
15 3 1 1
4 1 1 1
2 2 1 2
12 2 0 3
15 3 0 2
15 3 0 1
11 1 2 0
4 0 2 0
4 0 1 0
2 3 0 3
12 3 3 0
15 2 0 3
15 1 1 1
4 1 0 2
14 2 2 2
6 1 3 1
4 1 3 1
2 0 1 0
12 0 3 1
4 3 0 0
14 0 3 0
15 3 2 3
15 0 0 2
9 2 0 2
4 2 1 2
4 2 3 2
2 2 1 1
12 1 0 2
15 1 1 3
4 3 0 0
14 0 2 0
15 2 3 1
13 0 3 1
4 1 2 1
2 2 1 2
12 2 2 3
15 3 3 1
4 3 0 2
14 2 3 2
15 1 2 0
15 2 0 1
4 1 3 1
4 1 2 1
2 1 3 3
15 2 1 2
15 3 2 1
15 2 0 0
3 2 1 0
4 0 3 0
4 0 1 0
2 3 0 3
12 3 0 2
4 0 0 3
14 3 2 3
15 3 3 0
15 1 2 1
7 0 3 1
4 1 1 1
4 1 1 1
2 2 1 2
12 2 1 3
15 0 3 1
4 3 0 2
14 2 2 2
4 0 0 0
14 0 1 0
12 0 2 1
4 1 2 1
4 1 2 1
2 3 1 3
12 3 1 1
15 0 0 2
15 1 1 3
15 3 1 0
11 0 2 0
4 0 3 0
2 1 0 1
12 1 1 0
4 0 0 3
14 3 2 3
4 2 0 2
14 2 2 2
15 3 1 1
3 2 1 3
4 3 1 3
4 3 2 3
2 0 3 0
12 0 3 1
15 3 1 0
15 3 3 3
15 3 0 2
11 0 2 3
4 3 3 3
2 3 1 1
12 1 1 3
4 0 0 1
14 1 3 1
15 2 3 0
1 0 2 2
4 2 3 2
4 2 1 2
2 2 3 3
12 3 3 1
15 3 0 2
15 1 1 3
1 0 2 3
4 3 2 3
2 1 3 1
4 2 0 0
14 0 1 0
15 2 2 3
15 0 2 2
2 0 0 0
4 0 3 0
4 0 3 0
2 0 1 1
12 1 2 3
15 3 0 0
4 2 0 2
14 2 2 2
15 2 3 1
1 1 0 2
4 2 3 2
2 2 3 3
12 3 2 2
4 0 0 0
14 0 0 0
4 2 0 1
14 1 1 1
15 2 2 3
6 1 3 0
4 0 2 0
4 0 1 0
2 0 2 2
12 2 2 0
15 3 0 3
15 1 3 2
15 2 3 2
4 2 3 2
4 2 1 2
2 0 2 0
15 0 2 3
15 0 0 1
15 3 1 2
15 1 2 1
4 1 2 1
4 1 2 1
2 1 0 0
15 0 0 1
15 0 3 2
4 2 0 3
14 3 2 3
0 2 3 3
4 3 3 3
2 0 3 0
12 0 1 3
15 1 3 1
4 3 0 0
14 0 1 0
2 0 0 0
4 0 3 0
2 0 3 3
12 3 3 2
15 3 0 3
4 0 0 0
14 0 2 0
4 3 0 1
14 1 3 1
3 0 1 3
4 3 3 3
2 3 2 2
12 2 1 0
15 0 1 3
15 2 3 2
3 2 1 1
4 1 2 1
2 1 0 0
12 0 2 2
15 2 1 0
15 0 1 1
15 2 3 3
10 0 3 3
4 3 1 3
2 3 2 2
12 2 3 1
15 3 1 3
15 1 1 2
15 0 0 0
15 2 0 0
4 0 2 0
4 0 2 0
2 0 1 1
15 0 0 3
15 3 0 0
11 0 2 2
4 2 3 2
2 1 2 1
12 1 1 2
4 3 0 3
14 3 2 3
15 2 2 0
4 3 0 1
14 1 3 1
15 3 0 3
4 3 1 3
2 2 3 2
12 2 2 1
15 0 0 2
15 2 1 3
10 0 3 2
4 2 2 2
4 2 1 2
2 1 2 1
12 1 0 2
15 1 3 1
10 0 3 0
4 0 1 0
2 0 2 2
12 2 1 3
15 0 2 0
15 0 2 2
15 2 0 1
4 1 3 1
2 3 1 3
15 3 3 0
15 2 2 2
4 0 0 1
14 1 2 1
7 0 1 1
4 1 3 1
2 1 3 3
4 0 0 1
14 1 2 1
4 0 0 0
14 0 1 0
12 0 2 2
4 2 1 2
2 2 3 3
12 3 3 1
4 1 0 3
14 3 0 3
15 2 0 2
12 0 2 3
4 3 2 3
4 3 2 3
2 3 1 1
12 1 0 0
