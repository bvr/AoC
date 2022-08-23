
use 5.16.0; use strict; use warnings;
use Test::More;
use Path::Class qw(file);
use Algorithm::Combinatorics qw(combinations);
use List::Util qw(sum product);

# load data
my $input_file = "../input/01.txt";
my @input = file($input_file)->slurp(chomp => 1);

is find_2020_of(2, \@input), 776064, 'part1';
is find_2020_of(3, \@input), 6964490, 'part2';

sub find_2020_of {
    my ($n, $items) = @_;

    my $iter = combinations($items, $n);
    while(my $set = $iter->next) {
        return product(@$set) if sum(@$set) == 2020;
    }
}

done_testing;
