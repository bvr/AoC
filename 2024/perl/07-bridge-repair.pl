
# solution to https://adventofcode.com/2024/day/7

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use List::AllUtils qw(sum);

my $input_file = "../input/07.txt";
my @items = file($input_file)->slurp(chomp => 1);

my @test_items = split /\n/, <<END;
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
END

is sum(map { calibration_result($_, 0) } @test_items), 3749,            'part 1 - test';
is sum(map { calibration_result($_, 0) } @items),      1708857123053,   'part 1 - real';

is sum(map { calibration_result($_, 1) } @test_items), 11387,           'part 2 - test';
is sum(map { calibration_result($_, 1) } @items),      189207836795655, 'part 2 - real';

done_testing;

fun calibration_result($line, $use_concat) {
    my ($result, $items) = split /: /, $line;
    return can_be_solved($use_concat, $result, split /\s+/, $items) ? $result : 0;
}

fun can_be_solved($use_concat, $result, @items) {

    # basic cases
    return 0                    if @items == 0;            # nothing to do
    return $result == $items[0] if @items == 1;            # single item, just compare with result
    return 0                    if $result < $items[0];    # we are already over

    # collapse first two items and recurse
    return   can_be_solved($use_concat, $result, $items[0]+$items[1], @items[2..$#items]) 
        ||   can_be_solved($use_concat, $result, $items[0]*$items[1], @items[2..$#items])
        || ($use_concat 
           ? can_be_solved($use_concat, $result, $items[0].$items[1], @items[2..$#items]) 
           : 0);
}
