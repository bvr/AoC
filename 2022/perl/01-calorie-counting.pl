
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::Util qw(sum max);

my $input_file = "../input/01.txt";
my $in = file($input_file)->openr;

my @elf = ();
my $i = 0;
while(defined(my $line = <$in>)) {
    chomp($line);
    if($line eq '') { $i++; next; }
    $elf[$i] ||= [];
    push @{ $elf[$i] }, $line;
}

my $most_calories = max(map { sum(@$_) } @elf);
is $most_calories, 66306, 'part 1';

my @totals = sort { $b <=> $a } map { sum @$_ } @elf;
my $top_three = sum @totals[0..2];
is $top_three, 195292, 'part 2';

done_testing;

=head1 NAME

https://adventofcode.com/2022/day/1

=cut
