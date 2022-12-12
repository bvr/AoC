use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);
use Data::Dump qw(dd);

package Cargo {
    use Moo;
    use Function::Parameters;

    has stacks => (is => 'ro', default => sub { [] });

    method new_from_plan($class: @lines) {
        my @stacks;
        for my $box_line (grep { /\[\w\]/ } @lines) {
            my $i = 0;
            while(1) {
                my $pos = 1 + 4*$i;
                last if $pos > length($box_line);
                my $cargo = substr($box_line, $pos, 1);
                $stacks[$i] ||= [];
                push @{ $stacks[$i] }, $cargo if $cargo ne ' ';
                $i++;
            }
        }

        $class->new(stacks => \@stacks);
    }

    method moves_cm9000(@lines) {
        for my $line (@lines) {
            if(my ($count, $from, $to) = $line =~ /move (\d+) from (\d+) to (\d+)/) {
                for (1..$count) {
                    unshift(@{ $self->stacks->[$to-1] }, shift(@{ $self->stacks->[$from-1] }));
                }
            }
        }

        return $self;       # allow chaining
    }

    method moves_cm9001(@lines) {
        for my $line (@lines) {
            if(my ($count, $from, $to) = $line =~ /move (\d+) from (\d+) to (\d+)/) {
                my @load = splice @{ $self->stacks->[$from-1] }, 0, $count;
                unshift @{ $self->stacks->[$to-1] }, @load;
            }
        }

        return $self;       # allow chaining
    }

    method get_tops() {
        return join '', map { $_->[0] } @{ $self->stacks };
    }
}


my $input_file = "../input/05.txt";
my @plan = file($input_file)->slurp(chomp => 1);
my @test = (
    "    [D]    ",
    "[N] [C]    ",
    "[Z] [M] [P]",
    " 1   2   3 ",
    "",
    "move 1 from 2 to 1",
    "move 3 from 1 to 3",
    "move 2 from 2 to 1",
    "move 1 from 1 to 2",
);

is(Cargo->new_from_plan(@test)->moves_cm9000(@test)->get_tops(), "CMZ", "test part 1");
is(Cargo->new_from_plan(@plan)->moves_cm9000(@plan)->get_tops(), "VGBBJCRMN", "part 1");

is(Cargo->new_from_plan(@test)->moves_cm9001(@test)->get_tops(), "MCD", "test part 2");
is(Cargo->new_from_plan(@plan)->moves_cm9001(@plan)->get_tops(), "LBBVJBRMH", "part 2");

done_testing;
