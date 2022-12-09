
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);

my $input_file = "../input/03.txt";
my @items = file($input_file)->slurp(chomp => 1);

my @test_items = qw(
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw    
);

my $priority = 1;
my %priorities = map { $_ => $priority++ } 'a' .. 'z', 'A' .. 'Z';

is sum(map { find_duplicate_priority($_) } @test_items), 157, 'test part 1';
is sum(map { find_duplicate_priority($_) } @items), 7908, 'part 1';
is find_badge_priority(@test_items), 70, 'test part 2';
is find_badge_priority(@items), 2838, 'part 2';

done_testing;

# returns priority of shared 
sub find_duplicate_priority {
    my ($rucksack) = @_;

    my $p1 = substr($rucksack, 0, length($rucksack)/2);
    my $p2 = substr($rucksack, length($rucksack)/2);

    return $priorities{ find_common($p1, $p2) };
}

sub find_badge_priority {
    my $it = natatime 3, @_;

    my $sum_priority = 0;
    while(my @elfs = $it->()) {
        $sum_priority += $priorities{ find_common(@elfs) };
    }
    return $sum_priority;
}

# returns common character between supplied strings
sub find_common {
    my @items = @_;

    my %total;
    for my $i (@items) {
        my %chars = map { $_ => 1 } split //, $i;
        $total{$_}++ for keys %chars;
    }
    return first { $total{$_} == @items } keys %total;
}
