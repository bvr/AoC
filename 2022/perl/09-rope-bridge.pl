
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);

my $input_file = "../input/09.txt";
my @items = file($input_file)->slurp(chomp => 1);
my @tests = (
    "R 4",
    "U 4",
    "L 3",
    "D 1",
    "R 4",
    "D 1",
    "L 5",
    "R 2",
);

is num_positions_tail_visited(@tests), 13, 'part1 - test';



done_testing;

sub num_positions_tail_visited {
    my @instructions = @_;

    my %pos = ();
    my $head = [0,0];
    my $tail = [0,0];

    for my $in (@instructions) {

    }

}
