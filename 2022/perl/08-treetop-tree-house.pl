
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum max firstidx all);

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

is highest_score(\@tests), 8, 'test - part 2';
is highest_score(\@items), 8, 'part 2';

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

sub highest_score {
    my ($grid) = @_;

    my $maxy = $#$grid;
    my $maxx = length($grid->[0])-1;

    my $highest = 0;
    for my $y (0 .. $maxy) {
        for my $x (0 .. $maxx) {

            my $score = 1;

            # border
            if($x == 0 || $x == $maxx || $y == 0 || $y == $maxy) { 
                $score = 0;
            }
            else {
                my $curr = item($grid, $x, $y);

                # to the left and right
                $score *= 1 + num_items(sub { item($grid, $_, $y) >= $curr }, reverse(0..$x-1));
                $score *= 1 + num_items(sub { item($grid, $_, $y) >= $curr }, ($x+1..$maxx));

                # to the top and bottom
                $score *= 1 + num_items(sub { item($grid, $x, $_) >= $curr }, reverse(0..$y-1));
                $score *= 1 + num_items(sub { item($grid, $x, $_) >= $curr }, ($y+1..$maxy));
            }

            $highest = max($score, $highest);
        }
    }
    return $highest;
}

sub num_items(&@) {
    my $block = shift;
    my $stop = firstidx { $block->() } @_;
    return $stop == -1 ? $#_ : $stop;
}

sub item {
    my ($grid, $x, $y) = @_;
    return substr $grid->[$y], $x, 1;
}
