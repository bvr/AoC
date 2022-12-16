
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first all);

my $input_file = "../input/08.txt";
my @items = file($input_file)->slurp(chomp => 1);

my @tests = (
    "30373",
    "25512",
    "65332",
    "33549",
    "35390",
);

is count_visible(\@tests), 21, 'test - part 1';
is count_visible(\@items), 1546, 'part 1';

done_testing;

sub count_visible {
    my ($grid) = @_;

    my $maxy = $#$grid;
    my $maxx = length($grid->[0])-1;

    my $num_visible = 0;
    for my $y (0 .. $maxy) {
        for my $x (0 .. $maxx) {

            # border
            if($x == 0 || $x == $maxx || $y == 0 || $y == $maxy) { $num_visible++; next; }

            my $curr = item($grid, $x, $y);

            # to the left and right
            if(all { item($grid, $_, $y) < $curr } 0..$x-1)     { $num_visible++; next; }
            if(all { item($grid, $_, $y) < $curr } $x+1..$maxx) { $num_visible++; next; }

            # to the top and bottom
            if(all { item($grid, $x, $_) < $curr } 0..$y-1)     { $num_visible++; next; }
            if(all { item($grid, $x, $_) < $curr } $y+1..$maxy) { $num_visible++; next; }
        }
    }
    return $num_visible;
}

sub item {
    my ($grid, $x, $y) = @_;
    return substr $grid->[$y], $x, 1;
}
