
# solution to https://adventofcode.com/2024/day/6

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use List::AllUtils qw(sum natatime first);

use Map;

my $test_map = [ split /\n/, <<END ];
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
END

my $input_file = "../input/06.txt";
my $map = [ file($input_file)->slurp(chomp => 1) ];

is(Map->from_string($test_map)->guard_walk(), 41,   'part 1 - test');
is(Map->from_string($map)->guard_walk(),      5199, 'part 1 - real');

done_testing;
