
use 5.16.3;
use Test::More;
use Data::Dump;
use Path::Class qw(file);
use Iterator::Simple qw(iterator igrep list);
use List::AllUtils qw(pairwise);
use Carp::Always;

# load data
my $input_file = "../input/02.txt";
my @input = file($input_file)->slurp(chomp => 1);

# dd \@input;

dd $_ => { counts($_) }
    for qw(abcdef bababc abbcde abcccd aabcdd abcdee ababab);

my %totals = ( 2 => 0, 3 => 0 );
for my $i (@input) {
    my %counts = counts($i);
    for my $k (keys %totals) {
        $totals{$k}++ if exists $counts{$k};
    }
}
is $totals{2} * $totals{3}, 6642, 'part 1 - checksum';

use Algorithm::Combinatorics qw(combinations);
use Text::Levenshtein qw(distance);

my @test_input = qw(
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
);

my $it = combine(\@input, 2);
my $found = (igrep { distance($_->[0], $_->[1]) == 1 } $it)->next;
my @p1 = split //, $found->[0];
my @p2 = split //, $found->[1];
my $same_chars = join '', grep { defined } pairwise { $a eq $b ? $a : undef } @p1, @p2;
is $same_chars, 'cvqlbidheyujgtrswxmckqnap', 'part 2';

done_testing;

sub combine {
    my ($array, $num) = @_;
    my $it = combinations($array, $num);
    return iterator {
        return $it->next;
    };
}

sub counts {
    my ($str) = @_;

    my %counts = ();
    $counts{$_}++ for split //, $str;
    return reverse %counts;
}
