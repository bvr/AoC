
use 5.16.3;
use lib 'lib';
use Test::More;
use Data::Dump;
use Path::Class qw(file);
use Iterator::Simple qw(iterator igrep list);
use Utils qw(combine);

package Claim {
    use Moo;
    use Function::Parameters;

    has id     => (is => 'ro');
    has left   => (is => 'ro');
    has top    => (is => 'ro');
    has width  => (is => 'ro');
    has height => (is => 'ro');

    method new_from_input($class: $line) {
        die "Invalid input $line" unless $line =~ /#(\d+) \@ (\d+),(\d+): (\d+)x(\d+)/;
        return $class->new(
            id     => $1,
            left   => $2,
            top    => $3,
            width  => $4,
            height => $5,
        );
    }

    method color($matrix) {
        for my $r (0 .. $self->height-1) {
            for my $c (0 .. $self->width-1) {
                $matrix->[1000 * ($r + $self->top) + ($c + $self->left)]++;
            }
        }
    }

    method overlaps_with($claim) {
        # check x-axis
        return
            unless
                (   $self->left                     >= $claim->left
                &&  $self->left                     <= $claim->left + $claim->width - 1)
            ||  (   $self->left + $self->width - 1  >= $claim->left
                &&  $self->left + $self->width - 1  <= $claim->left + $claim->width - 1)
            ||  (   $self->left                     <  $claim->left
                &&  $self->left + $self->width - 1  >  $claim->left + $claim->width -1);

        # check y-axis
        return 1
            if  (   $self->top                      >= $claim->top
                &&  $self->top                      <= $claim->top + $claim->height - 1)
            ||  (   $self->top + $self->height - 1  >= $claim->top
                &&  $self->top + $self->height - 1  <= $claim->top + $claim->height - 1)
            ||  (   $self->top                      <  $claim->top
                &&  $self->top + $self->height - 1  >  $claim->top + $claim->height - 1);

        return 0;
    }
}


my $input_file = "../input/03.txt";
my @input = file($input_file)->slurp(chomp => 1);

my @claims = map { Claim->new_from_input($_) } @input;

my $matrix = [];
$_->color($matrix) for @claims;

my $total = 0;
for my $item (@$matrix) {
    $total++ if $item > 1;
}

is $total, 116140, 'part 1';

my @test_claims = (
    Claim->new_from_input('#1 @ 1,3: 4x4'),
    Claim->new_from_input('#2 @ 3,1: 4x4'),
    Claim->new_from_input('#3 @ 5,5: 2x2'),
);

my @test_non_overlapping = claims_non_overlapped(\@test_claims);
is scalar @test_non_overlapping, 1, 'part 2 - test number of items';
is $test_non_overlapping[0]->id, 3, 'part 2 - test claim id';

my @non_overlapping = claims_non_overlapped(\@claims);
is scalar @non_overlapping, 1,   'part 2 - number of items';
is $non_overlapping[0]->id, 574, 'part 2 - claim id';

done_testing;


sub claims_non_overlapped {
    my ($claims) = @_;
    my $it = combine($claims, 2);

    my %overlapped = ();
    while(my $c = $it->next) {
        if($c->[0]->overlaps_with($c->[1])) {
            @overlapped{$c->[0]->id, $c->[1]->id} = ();
        }
    }
    return grep { ! exists $overlapped{$_->id} } @$claims;
}

=head1 ASSIGNMENT

https://adventofcode.com/2018/day/3

=head2 --- Day 3: No Matter How You Slice It ---

The Elves managed to locate the chimney-squeeze prototype fabric for Santa's
suit (thanks to someone who helpfully wrote its box IDs on the wall of the
warehouse in the middle of the night). Unfortunately, anomalies are still
affecting them - nobody can even agree on how to cut the fabric.

The whole piece of fabric they're working on is a very large square - at least
1000 inches on each side.

Each Elf has made a claim about which area of fabric would be ideal for Santa's
suit. All claims have an ID and consist of a single rectangle with edges
parallel to the edges of the fabric. Each claim's rectangle is defined as
follows:

    The number of inches between the left edge of the fabric and the left edge of the rectangle.
    The number of inches between the top edge of the fabric and the top edge of the rectangle.
    The width of the rectangle in inches.
    The height of the rectangle in inches.

A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3
inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4
inches tall. Visually, it claims the square inches of fabric represented
by # (and ignores the square inches of fabric represented by .) in the diagram
below:

    ...........
    ...........
    ...#####...
    ...#####...
    ...#####...
    ...#####...
    ...........
    ...........
    ...........

The problem is that many of the claims overlap, causing two or more claims to
cover part of the same areas. For example, consider the following claims:

    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2

Visually, these claim the following areas:

    ........
    ...2222.
    ...2222.
    .11XX22.
    .11XX22.
    .111133.
    .111133.
    ........

The four square inches marked with X are claimed by both 1 and 2. (Claim 3,
while adjacent to the others, does not overlap either of them.)

If the Elves all proceed with their own plans, none of them will have enough
fabric. How many square inches of fabric are within two or more claims?

Your puzzle answer was 116140.

--- Part Two ---

Amidst the chaos, you notice that exactly one claim doesn't overlap by even a
single square inch of fabric with any other claim. If you can somehow draw
attention to it, maybe the Elves will be able to make Santa's suit after all!

For example, in the claims above, only claim 3 is intact after all claims are made.

What is the ID of the only claim that doesn't overlap?

Your puzzle answer was 574.

=cut
