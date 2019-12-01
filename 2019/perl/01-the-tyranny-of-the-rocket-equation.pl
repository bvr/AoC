
use 5.16.0; use strict; use warnings;
use Test::More;
use Path::Class qw(file);
use List::Util qw(sum);

# load data
my $input_file = "../input/01.txt";
my @input = file($input_file)->slurp(chomp => 1);

is fuel_required(12),     2,     'part 1 - example';
is fuel_required(14),     2,     'part 1 - example';
is fuel_required(1969),   654,   'part 1 - example';
is fuel_required(100756), 33583, 'part 1 - example';

is sum(map { fuel_required($_) } @input), 3369286, 'part 1';

is fuel_additive(14),     2,     'part 2 - example';
is fuel_additive(1969),   966,   'part 2 - example';
is fuel_additive(100756), 50346, 'part 2 - example';

is sum(map { fuel_additive($_) } @input), 5051054, 'part 2';

done_testing;

sub fuel_required {
    my ($mass) = @_;
    return int($mass/3) - 2;
}

sub fuel_additive {
    my ($mass_module) = @_;

    my $total = 0;
    my $mass = $mass_module;
    while((my $added = fuel_required($mass)) > 0) {
        $total += $added;
        $mass = $added;
    }
    return $total;
}


=head1 ASSIGNMENT

https://adventofcode.com/2019/day/1

=head2 --- Day 1: The Tyranny of the Rocket Equation ---

Santa has become stranded at the edge of the Solar System while delivering
presents to other planets! To accurately calculate his position in space,
safely align his warp drive, and return to Earth in time to save Christmas, he
needs you to bring him measurements from fifty stars.

Collect stars by solving puzzles. Two puzzles will be made available on each
day in the Advent calendar; the second puzzle is unlocked when you complete the
first. Each puzzle grants one star. Good luck!

The Elves quickly load you into a spacecraft and prepare to launch.

At the first Go / No Go poll, every Elf is Go until the Fuel Counter-Upper.
They haven't determined the amount of fuel required yet.

Fuel required to launch a given module is based on its mass. Specifically, to
find the fuel required for a module, take its mass, divide by three, round
down, and subtract 2.

For example:

=over

=item * For a mass of 12, divide by 3 and round down to get 4, then subtract 2
to get 2.

=item * For a mass of 14, dividing by 3 and rounding down still yields 4, so
the fuel required is also 2.

=item * For a mass of 1969, the fuel required is 654.

=item * For a mass of 100756, the fuel required is 33583.

=back

The Fuel Counter-Upper needs to know the total fuel requirement. To find it,
individually calculate the fuel needed for the mass of each module (your puzzle
input), then add together all the fuel values.

What is the sum of the fuel requirements for all of the modules on your
spacecraft?

Your puzzle answer was 3369286.

=head2 --- Part Two ---

During the second Go / No Go poll, the Elf in charge of the Rocket Equation
Double-Checker stops the launch sequence. Apparently, you forgot to include
additional fuel for the fuel you just added.

Fuel itself requires fuel just like a module - take its mass, divide by three,
round down, and subtract 2. However, that fuel also requires fuel, and that
fuel requires fuel, and so on. Any mass that would require negative fuel should
instead be treated as if it requires zero fuel; the remaining mass, if any, is
instead handled by wishing really hard, which has no mass and is outside the
scope of this calculation.

So, for each module mass, calculate its fuel and add it to the total. Then,
treat the fuel amount you just calculated as the input mass and repeat the
process, continuing until a fuel requirement is zero or negative. For example:

=over

=item * A module of mass 14 requires 2 fuel. This fuel requires no further
fuel (2 divided by 3 and rounded down is 0, which would call for a negative
fuel), so the total fuel required is still just 2.

=item * At first, a module of mass 1969 requires 654 fuel. Then, this fuel
requires 216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel, which
requires 21 fuel, which requires 5 fuel, which requires no further fuel. So,
the total fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 =
966.

=item * The fuel required by a module of mass 100756 and its fuel is: 33583 +
11192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.

=back

What is the sum of the fuel requirements for all of the modules on your
spacecraft when also taking into account the mass of the added fuel? (Calculate
the fuel requirements for each module separately, then add them all up at the
end.)

Your puzzle answer was 5051054.

Both parts of this puzzle are complete! They provide two gold stars: **

=cut
