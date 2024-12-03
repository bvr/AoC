
# solution to https://adventofcode.com/2024/day/3

use Test2::V0;
use Path::Class qw(file);
use List::AllUtils qw(sum);

my $input_file = "../input/03.txt";
my $memory = file($input_file)->slurp(chomp => 1);

my $total_part1 = 0;
my $total_part2 = 0;
my $enabled = 1;
while($memory =~ /(?: (?<op>mul)\((?<n1>\d+),(?<n2>\d+)\) | (?<op>do)\(\) | (?<op>don't)\(\) )/gsx) {
    $+{op} eq 'mul' and do {
        $total_part1 += $+{n1} * $+{n2};
        $total_part2 += $+{n1} * $+{n2}  if $enabled;
    };
    $+{op} eq 'do'     and $enabled = 1;
    $+{op} eq 'don\'t' and $enabled = 0;
}

is $total_part1, 181345830, 'part 1';
is $total_part2, 98729041,  'part 2';

done_testing;
