
use 5.16.3;
use lib 'lib';
use Test::More;
use Path::Class qw(file);
use Iterator::Simple qw(iterator igrep list);
use List::AllUtils qw(pairwise);
use Utils qw(combine);

# load data
my $input_file = "../input/02.txt";
my @input = file($input_file)->slurp(chomp => 1);

my @example_input = qw(
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
);
is checksum(\@example_input), 12,   'part 1 - example';
is checksum(\@input),         6642, 'part 1 - checksum';

my @test_input = qw(
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
);
is common_part_of_box_id(\@test_input), 'fgij',                      'part 2 - example';
is common_part_of_box_id(\@input),      'cvqlbidheyujgtrswxmckqnap', 'part 2 - full input';

done_testing;

sub checksum {
    my ($array) = @_;
    my %total = count_repetitions($array);
    return $total{2} * $total{3};
}

sub count_repetitions {
    my ($array) = @_;

    my %totals = ();
    for my $i (@$array) {
        my %reps = repeated_chars($i);
        $totals{$_}++ for keys %reps;
    }
    return %totals;
}

sub repeated_chars {
    my ($str) = @_;

    my %counts = ();
    $counts{$_}++ for split //, $str;
    return reverse %counts;     # { count => 'char', ... }
}

sub common_part_of_box_id {
    my ($array) = @_;

    # find ids with only one char difference
    my $it = combine($array, 2);
    my $found = (igrep { only_one_difference($_->[0], $_->[1]) } $it)->next;

    # return common characters
    my @p1 = split //, $found->[0];
    my @p2 = split //, $found->[1];
    return join '', grep { defined } pairwise { $a eq $b ? $a : undef } @p1, @p2;
}

sub only_one_difference {
    my ($s1, $s2) = @_;
    my $len = length($s1);
    return unless length($s2) == $len;
    my $diff = 0;
    my $i = 0;
    while($i < $len) {
        $diff++ if substr($s1,$i,1) ne substr($s2,$i,1);
        return if $diff > 1;
        $i++;
    }
    return 1;
}

=head1 ASSIGNMENT

https://adventofcode.com/2018/day/2

=head2 --- Day 2: Inventory Management System ---

You stop falling through time, catch your breath, and check the screen on the
device. "Destination reached. Current Year: 1518. Current Location: North Pole
Utility Closet 83N10." You made it! Now, to find those anomalies.

Outside the utility closet, you hear footsteps and a voice. "...I'm not sure
either. But now that so many people have chimneys, maybe he could sneak in that
way?" Another voice responds, "Actually, we've been working on a new kind of
suit that would let him fit through tight spaces like that. But, I heard that a
few days ago, they lost the prototype fabric, the design plans, everything!
Nobody on the team can even seem to remember important details of the project!"

"Wouldn't they have had enough fabric to fill several boxes in the warehouse?
They'd be stored together, so the box IDs should be similar. Too bad it would
take forever to search the warehouse for two similar box IDs..." They walk too
far away to hear any more.

Late at night, you sneak to the warehouse - who knows what kinds of paradoxes
you could cause if you were discovered - and use your fancy wrist device to
quickly scan every box and produce a list of the likely candidates (your puzzle
input).

To make sure you didn't miss any, you scan the likely candidate boxes again,
counting the number that have an ID containing exactly two of any letter and
then separately counting those with exactly three of any letter. You can
multiply those two counts together to get a rudimentary checksum and compare it
to what your device predicts.

For example, if you see the following box IDs:

    abcdef contains no letters that appear exactly two or three times.
    bababc contains two a and three b, so it counts for both.
    abbcde contains two b, but no letter appears exactly three times.
    abcccd contains three c, but no letter appears exactly two times.
    aabcdd contains two a and two d, but it only counts once.
    abcdee contains two e.
    ababab contains three a and three b, but it only counts once.

Of these box IDs, four of them contain a letter which appears exactly twice,
and three of them contain a letter which appears exactly three times.
Multiplying these together produces a checksum of 4 * 3 = 12.

What is the checksum for your list of box IDs?

Your puzzle answer was 6642.

=head2 --- Part Two ---

Confident that your list of box IDs is complete, you're ready to find the boxes
full of prototype fabric.

The boxes will have IDs which differ by exactly one character at the same
position in both strings. For example, given the following box IDs:

    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz

The IDs abcde and axcye are close, but they differ by two characters (the
second and fourth). However, the IDs fghij and fguij differ by exactly one
character, the third (h and u). Those must be the correct boxes.

What letters are common between the two correct box IDs? (In the example above,
this is found by removing the differing character from either ID, producing
fgij.)

Your puzzle answer was cvqlbidheyujgtrswxmckqnap.

=cut
