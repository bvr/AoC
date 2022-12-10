
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);
use Data::Dump qw(dd);

sub build_ranges {
    my ($line) = @_;
    return [ map { Range->new_from_numbers(split /-/, $_) } split /,/, $line ];
}

package Range {
    use Moo;
    use Function::Parameters;

    has from => (is => 'ro');
    has to   => (is => 'ro');

    method new_from_numbers($class: $from, $to) {
        $class->new(from => $from, to => $to);
    }

    method fully_overlaps_with($other) {
        return ($self->from <= $other->from && $other->to <= $self->to)
            || ($other->from <= $self->from && $self->to <= $other->to);
    }

    method overlaps_with($other) {
        return ($self->from <= $other->from && $other->from <= $self->to)
            || ($self->from <= $other->to   && $other->to   <= $self->to)
            || ($other->from <= $self->from && $self->from  <= $other->to)
            || ($other->from <= $self->to   && $self->to    <= $other->to);            
    }
}


my $input_file = "../input/04.txt";
my @items = file($input_file)->slurp(chomp => 1);
my @test_items = (
    "2-4,6-8",
    "2-3,4-5",
    "5-7,7-9",
    "2-8,3-7",
    "6-6,4-6",
    "2-6,4-8",
);

my @test_ranges = map { build_ranges($_) } @test_items;
my @ranges      = map { build_ranges($_) } @items;

# part 1
is scalar(grep { $_->[0]->fully_overlaps_with($_->[1]) } @test_ranges), 2, "test part1";
is scalar(grep { $_->[0]->fully_overlaps_with($_->[1]) } @ranges), 498, "part1";

# part 2
is scalar(grep { $_->[0]->overlaps_with($_->[1]) } @test_ranges), 4, "test part2";
is scalar(grep { $_->[0]->overlaps_with($_->[1]) } @ranges), 859, "part2";

done_testing;
