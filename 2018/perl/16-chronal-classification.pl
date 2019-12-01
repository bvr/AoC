
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(natatime pairmap lastidx extract_by);
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

my @opcodes = ();
my @opcodes2 = qw(
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

is_deeply
    [ sample_match([3, 2, 1, 1], [9, 2, 1, 2], [3, 2, 2, 1]) ],
    [qw(addi mulr seti)],
    'sample match';

my $input_file = "../input/16.txt";
my @input = file($input_file)->slurp(chomp => 1);
my $last_sample_idx = lastidx { /After/ } @input;
my @samples = @input[0 .. $last_sample_idx];
my @code    = @input[$last_sample_idx+1 .. $#input];

my $sample = natatime 4, @samples;
my $count = 0;
my @queue;
while(my @line = $sample->()) {
    my $before = [ $line[0] =~ /\d+/g ];
    my $op     = [ $line[1] =~ /\d+/g ];
    my $after  = [ $line[2] =~ /\d+/g ];

    my $opcode = $op->[0];
    my @names = sample_match($before, $op, $after);

    # remove known
    extract_by { defined $inst{$_}{opcode} } @names;
    if(@names == 1) {
        $opcodes[$opcode] = $names[0];
        $inst{ $names[0] }{opcode} = $opcode;

        while(@queue) {
            my $change = 0;
            for my $q (@queue) {
                extract_by { defined $inst{$_}{opcode} } @{ $q->{names} };
                if(@{ $q->{names} } == 1) {
                    $opcodes[$opcode] = $q->{names}[0];
                    $inst{ $names[0] }{opcode} = $q->{opcode};
                    $change++;
                }
            }
            last unless $change;
            extract_by { @{ $_->{names} } <= 1 } @queue;
        }
    }
    else {
        push @queue, { opcode => $opcode, names => [ @names ] };
    }

    # dd \@queue, \@opcodes;

    $count++ if @names >= 3;
}
is $count, 614, 'part 1';

# dd \%histogram;
# dd \@opcodes;

my $registers = [0,0,0,0];
for(@code) {
    next unless my @line = /\d+/g;
    $registers = $inst{ $opcodes[ $line[0] ] }->{exec}->(@line[1..3], $registers);
}
is $registers->[0], 656, 'part 2 - execution';


done_testing;


sub sample_match {
    my ($before, $inst, $after) = @_;

    my %names = ();
    while(my ($code, $i) = each %inst) {
        my $regs = $i->{exec}->($inst->[1], $inst->[2], $inst->[3], $before);
        $names{ $code }++ if $regs ~~ $after;
    }

    return sort keys %names;
}

sub build_instructions {
    return pairmap {
        my $code = $b;
        $code =~ s/\b([ab])\b/\$$1/g;
        $code =~ s/\br([ab])\b/\$r->[\$$1]/g;
        $a => {
            opcode => undef,
            exec   => quote_sub(q{ my ($a, $b, $c, $r) = @_; my $res = eval pp $r; $res->[$c] = } . $code . q{ ; return $res }),
        }
    } @_;
}
