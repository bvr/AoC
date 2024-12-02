
# solution to https://adventofcode.com/2024/day/1

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters; 
use List::AllUtils qw(sum pairwise count_by);

# load/parse test and real data
my $test_data = parse_input(split /\n/, <<END);
3   4
4   3
2   5
1   3
3   9
3   3
END
my $input_file = '../input/01.txt';
my $data = parse_input(file($input_file)->slurp(chomp => 1));

# part 1
is list_distance($test_data), 11, 'part 1 - test';
is list_distance($data), 1970720, 'part 1 - real data';

# part 2
is similarity_score($test_data), 31,  'part 2 - test';
is similarity_score($data), 17191599, 'part 2 - real data';

done_testing;

fun parse_input(@input) {
    my (@a, @b);
    for my $line (@input) {
        my ($left, $right) = split /\s+/, $line;
        push @a, $left;
        push @b, $right;
    }
    return [ \@a, \@b ];
}

fun list_distance($input) {
    my @sorted_a = sort @{ $input->[0] };
    my @sorted_b = sort @{ $input->[1] };
    no warnings 'once';
    return sum( pairwise { abs($a - $b) } @sorted_a, @sorted_b );
}

fun similarity_score($input) {
    my %counts_b = count_by { $_ } @{ $input->[1] };
    return sum( map { $_ * ($counts_b{$_}//0) } @{ $input->[0] } );
}
