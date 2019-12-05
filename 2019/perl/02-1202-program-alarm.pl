
use 5.16.3;
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw();
use Data::Dump     qw(pp);

use constant {
    OP_ADD  => 1,
    OP_MUL  => 2,
    OP_HALT => 99,
};

my $input_file = "../input/02.txt";
my @input = split /,/, file($input_file)->slurp(chomp => 1);

is_deeply ship_computer([1, 0, 0, 0, 99]), [2, 0, 0, 0, 99], 'part 1 - example';
is_deeply ship_computer([2, 3, 0, 3, 99]), [2, 3, 0, 6, 99], 'part 1 - example';
is_deeply ship_computer([2, 4, 4, 5, 99, 0]), [2, 4, 4, 5, 99, 9801], 'part 1 - example';
is_deeply ship_computer([1, 1, 1, 4, 99, 5, 6, 0, 99]), [30, 1, 1, 4, 2, 5, 6, 0, 99], 'part 1 - example';

# setup
$input[1] = 12;
$input[2] = 2;
is +(ship_computer(\@input))->[0], 3931283, 'part 1';

# brute force part 2
for my $i (0 .. $#input) {
    for my $j (0 .. $#input) {
        $input[1] = $i;
        $input[2] = $j;
        warn $i, $j, "\n" if ship_computer(\@input)->[0] == 19690720;
    }
}

done_testing;

sub ship_computer {
    my $memory = eval pp $_[0];
    my $pc = 0;
    while(1) {
        my $opcode = $memory->[$pc];

        last if $opcode == OP_HALT;

        my ($a, $b, $r) = map { $memory->[$pc + $_] } 1,2,3;

        if($opcode == OP_ADD) {
            $memory->[$r] = $memory->[$a] + $memory->[$b];
        }
        elsif($opcode == OP_MUL) {
            $memory->[$r] = $memory->[$a] * $memory->[$b];
        }
        else {
            die "Invalid instruction";
        }
        $pc += 4;
    }
    return $memory;
}


=head1 ASSIGNMENT

https://adventofcode.com/2019/day/2

=cut
