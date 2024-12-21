
# solution to https://adventofcode.com/2024/day/8

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use List::AllUtils qw(sum natatime first);
use Data::Dump qw(dd);

use Grid;

my $input_file = "../input/08.txt";
my $grid = Grid->from_string([file($input_file)->slurp(chomp => 1)]);

my $test_grid = Grid->from_string([qw(
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
)]);

dd $test_grid;

done_testing;

