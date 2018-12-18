
use 5.16.3;
use lib 'lib';
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw();
use Data::Dump;

use CollectionArea;

my $test_area = CollectionArea->new_from_string(<<END);
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
END

$test_area = $test_area->new_generation() for 1..10;
is $test_area->resource_value, 1147, 'part 1 - test';

# part 1
my $input_file = "../input/18.txt";
my $input = file($input_file)->slurp();
my $area = CollectionArea->new_from_string($input);
$area = $area->new_generation() for 1..10;
is $area->resource_value, 355918, 'part 1';

# part 2
my %seen = ();
my $area = CollectionArea->new_from_string($input);
my $i = 0;
$seen{ $area->to_string() } = [$i, $area->resource_value];
while(1) {
    $area = $area->new_generation();
    my $sig = $area->to_string();
    if(my $old = $seen{$sig}) {
        # warn "Generation $i was seen as $old->[0]\n";
        my $num_in_seq = (1_000_000_000 - $old->[0]) % ($i + 1 - $old->[0]);
        for my $k (keys %seen) {
            my $val = $seen{$k};
            if($val->[0] == $num_in_seq + $old->[0]) {
                warn "$val->[0]: $val->[1]\n";
                is $val->[0], 524, 'part 2 - repeated iteration number';
                is $val->[1], 202806, 'part 2';
            }
        }
        last;
    }
    $seen{$sig} = [++$i, $area->resource_value];
    # warn ">>> $i\n" if $i % 100 == 0;
}

done_testing;

=head1 ASSIGNMENT

https://adventofcode.com/2018/day/18

=head2 --- Day 18: Settlers of The North Pole ---

On the outskirts of the North Pole base construction project, many Elves are
collecting lumber.

The lumber collection area is 50 acres by 50 acres; each acre can be either
open ground (.), trees (|), or a lumberyard (#). You take a scan of the
area (your puzzle input).

Strange magic is at work here: each minute, the landscape looks entirely
different. In exactly one minute, an open acre can fill with trees, a wooded
acre can be converted to a lumberyard, or a lumberyard can be cleared to open
ground (the lumber having been sent to other projects).

The change to each acre is based entirely on the contents of that acre as well
as the number of open, wooded, or lumberyard acres adjacent to it at the start
of each minute. Here, "adjacent" means any of the eight acres surrounding that
acre. (Acres on the edges of the lumber collection area might have fewer than
eight adjacent acres; the missing acres aren't counted.)

In particular:

=over

=item * An open acre will become filled with trees if three or more adjacent
acres contained trees. Otherwise, nothing happens.

=item * An acre filled with trees will become a lumberyard if three or more
adjacent acres were lumberyards. Otherwise, nothing happens.

=item * An acre containing a lumberyard will remain a lumberyard if it was
adjacent to at least one other lumberyard and at least one acre containing
trees. Otherwise, it becomes open.

=back

These changes happen across all acres simultaneously, each of them using the
state of all acres at the beginning of the minute and changing to their new
form by the end of that same minute. Changes that happen during the minute
don't affect each other.

For example, suppose the lumber collection area is instead only 10 by 10 acres
with this initial configuration:

    Initial state:
    .#.#...|#.
    .....#|##|
    .|..|...#.
    ..|#.....#
    #.#|||#|#|
    ...#.||...
    .|....|...
    ||...#|.#|
    |.||||..|.
    ...#.|..|.

    After 1 minute:
    .......##.
    ......|###
    .|..|...#.
    ..|#||...#
    ..##||.|#|
    ...#||||..
    ||...|||..
    |||||.||.|
    ||||||||||
    ....||..|.

    After 2 minutes:
    .......#..
    ......|#..
    .|.|||....
    ..##|||..#
    ..###|||#|
    ...#|||||.
    |||||||||.
    ||||||||||
    ||||||||||
    .|||||||||

    After 3 minutes:
    .......#..
    ....|||#..
    .|.||||...
    ..###|||.#
    ...##|||#|
    .||##|||||
    ||||||||||
    ||||||||||
    ||||||||||
    ||||||||||

    After 4 minutes:
    .....|.#..
    ...||||#..
    .|.#||||..
    ..###||||#
    ...###||#|
    |||##|||||
    ||||||||||
    ||||||||||
    ||||||||||
    ||||||||||

    After 5 minutes:
    ....|||#..
    ...||||#..
    .|.##||||.
    ..####|||#
    .|.###||#|
    |||###||||
    ||||||||||
    ||||||||||
    ||||||||||
    ||||||||||

    After 6 minutes:
    ...||||#..
    ...||||#..
    .|.###|||.
    ..#.##|||#
    |||#.##|#|
    |||###||||
    ||||#|||||
    ||||||||||
    ||||||||||
    ||||||||||

    After 7 minutes:
    ...||||#..
    ..||#|##..
    .|.####||.
    ||#..##||#
    ||##.##|#|
    |||####|||
    |||###||||
    ||||||||||
    ||||||||||
    ||||||||||

    After 8 minutes:
    ..||||##..
    ..|#####..
    |||#####|.
    ||#...##|#
    ||##..###|
    ||##.###||
    |||####|||
    ||||#|||||
    ||||||||||
    ||||||||||

    After 9 minutes:
    ..||###...
    .||#####..
    ||##...##.
    ||#....###
    |##....##|
    ||##..###|
    ||######||
    |||###||||
    ||||||||||
    ||||||||||

    After 10 minutes:
    .||##.....
    ||###.....
    ||##......
    |##.....##
    |##.....##
    |##....##|
    ||##.####|
    ||#####|||
    ||||#|||||
    ||||||||||

After 10 minutes, there are 37 wooded acres and 31 lumberyards. Multiplying the
number of wooded acres by the number of lumberyards gives the total resource
value after ten minutes: 37 * 31 = 1147.

What will the total resource value of the lumber collection area be after 10
minutes?

Your puzzle answer was 355918.

=head2 --- Part Two ---

This important natural resource will need to last for at least thousands of
years. Are the Elves collecting this lumber sustainably?

What will the total resource value of the lumber collection area be after
1000000000 minutes?

Your puzzle answer was 202806.

=cut
