
# solution to https://adventofcode.com/2024/day/6

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use List::AllUtils qw(sum natatime first);

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



done_testing;

package Point {
    use Moo;
    use Types::Standard qw(Int);
    use Function::Parameters;

    has x => (is => 'ro', isa => Int);
    has y => (is => 'ro', isa => Int);

    method offset($dx, $dy) {
        return Point->new(x => $self->x + $dx, y => $self->y + $dy);
    }
}

package Map {
    use Moo;
    use Types::Standard qw(Int Str Enum ArrayRef InstanceOf);
    use Function::Parameters;
    
    has map   => (is => 'ro', isa => ArrayRef[Str]);
    has guard => (is => 'ro', isa => InstanceOf['Point']);

    method from_string($class: $map_data) {
        my $map = Map->new(map => $map_data);
        $map->_find_guard();
        return $map;
    }

    method _find_guard() {
        # locate ^ in all strings of the map
        # set guard property
    }

    method guard_steps() {
        
    }

    method at($pos) {
        return '' if $pos->x < 0 || $pos->y < 0;
        return '' if $pos->x > length($self->map->[$pos->y]);
        return substr($self->map->[$pos->y], $pos->x, 1);
    }
}
