
use 5.16.3;
use Test::More;
use Algorithm::Combinatorics qw(variations_with_repetition);
use List::AllUtils qw(max_by sum);
use Memoize;
use Data::Dump;

my $input = 2568;

is power_level(3,5, 8),      4, 'part 1 - test power';
is power_level(122,79, 57), -5, 'part 1 - test power';
is power_level(217,196, 39), 0, 'part 1 - test power';
is power_level(101,153, 71), 4, 'part 1 - test power';

memoize('max_power');
is_deeply max_power(3, $input)->{loc}, [21,68], 'part 1';

my ($best_result, $max_power);
for my $size (1..300) {
    warn "$size\n";
    my $for_size = max_power($size, $input);
    if(! defined $max_power || $for_size->{power} > $max_power) {
        $best_result = $for_size;
        $best_result->{size} = $size;
        $max_power = $for_size->{power};
    }
}
dd $best_result;


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
