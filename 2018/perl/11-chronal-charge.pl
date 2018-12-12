
use 5.16.3;
use lib 'lib';
use Test::More;
use Algorithm::Combinatorics qw(variations_with_repetition);
use Iterator::Simple qw(imap list);
use Utils qw(accumulate);
use List::AllUtils qw(max_by sum);
use Data::Dump;

my $input = 2568;
my $MAX = 300;

is power_level(3,5, 8),      4, 'part 1 - test power';
is power_level(122,79, 57), -5, 'part 1 - test power';
is power_level(217,196, 39), 0, 'part 1 - test power';
is power_level(101,153, 71), 4, 'part 1 - test power';

my $part1_result = max_power(3, $input);
is_deeply $part1_result->{loc},   [21,68], 'part 1 - location';
is        $part1_result->{power}, 29,      'part 1 - size';

# from https://en.wikipedia.org/wiki/Summed-area_table

my @mat = (
    [ 1, 2, 3, 4, 6 ],
    [ 5, 3, 8, 1, 2 ],
    [ 4, 6, 7, 5, 5 ],
    [ 2, 4, 8, 9, 4 ],
    [ 2, 4, 8, 9, 4 ],
);




my @summed_table;
for my $x (0..4) {
    for my $y (0..4) {
        $summed_table[$x][$y]
            = $mat[$x][$y]
                + $summed_table[$x][$y-1]//0
                + $summed_table[$x-1][$y]//0
                - $summed_table[$x-1][$y-1]//0;
    }
}

dd \@summed_table;

my $loc = [21, 68];
my @coords = variations_with_repetition([0..2], 2);
my $power = sum map { power_level($loc->[0] + $_->[0], $loc->[1] + $_->[1], $input) } @coords;
is $power, 29;

is sum_area(21,68, 23,70), 29, 'test summed table';

# dd \@summed_table;




# my ($best_result, $max_power);
# for my $size (1..300) {
#     warn "$size\n";
#     my $for_size = max_power($size, $input);
#     if(! defined $max_power || $for_size->{power} > $max_power) {
#         $best_result = $for_size;
#         $best_result->{size} = $size;
#         $max_power = $for_size->{power};
#     }
# }
# dd $best_result;


sub sum_area {
    my ($x1, $y1, $x2, $y2) = @_;

    $x1--;
    $y1--;
    return $summed_table[$x2][$y2] + $summed_table[$x1][$y1]
         - $summed_table[$x2][$y1] - $summed_table[$x1][$y2];
}


sub power_level {
    my ($x, $y, $serial) = @_;

    my $rack_id = $x + 10;
    return substr(($rack_id * $y + $serial) * $rack_id, -3, 1) - 5;
}

sub max_power {
    my ($size, $serial) = @_;

    my @coords = variations_with_repetition([0..$size-1],     2);
    my @loc    = variations_with_repetition([1..300-$size+1], 2);

    my ($best_loc, $max_power);
    for my $loc (@loc) {
        my $power = sum map { power_level($loc->[0] + $_->[0], $loc->[1] + $_->[1], $serial) } @coords;
        if(! defined $max_power || $power > $max_power) {
            ($best_loc, $max_power) = ($loc, $power);
        }
    }
    return { loc => $best_loc, power => $max_power };
}

done_testing;
