
use 5.16.3;
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(all first);
use Data::Dump     qw(dd pp);

my $input_file = "../input/07.txt";
my @input = file($input_file)->slurp(chomp => 1);

my @test = split /\n/, <<END;
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
END

is execute_work(\@test)->{result}, 'CABDFE', 'part 1 - test';

my $test_result = execute_work(\@test, 2);
is $test_result->{result},         'CAFBDE', 'part 2 - test';
is $test_result->{time},           258,      'part 2 - test';

is step_duration('A'), 61, 'step duration';
is step_duration('C'), 63, 'step duration';

is execute_work(\@input)->{result}, 'EBICGKQOVMYZJAWRDPXFSUTNLH', 'part 1';

my $input_result = execute_work(\@input, 5);
is $input_result->{result},         'EIVZBCGYJKAQWORMDPXFSUTNLH', 'part 2 - result';
is $input_result->{time},           906,                          'part 2 - time';

done_testing;


sub execute_work {
    my ($lines, $num_workers) = @_;

    $num_workers ||= 1;         # default

    # build data
    my %done    = ();
    my %before  = ();
    for my $ln (@$lines) {
        if($ln =~ /Step (\w) must be finished before step (\w) can begin/) {
            $before{$2} ||= [];
            push @{ $before{$2} }, $1;
            @done{$1, $2} = ();
        }
    }

    # processing
    my %in_work = ();
    my $result = '';
    my $second = 0;
    my @workers = ();
    push @workers, []  for 1..$num_workers;
    while(! all { $_ } values %done) {

        # available steps
        my @avail = sort
            grep {
                my $step = $_;
                all { $done{$_} == 1 } @{$before{$step}}
            }
            grep { ! $done{$_} && ! $in_work{$_} }
            keys %done;

        # start work
        while(my $step = shift @avail) {
            my $free_worker = first { ! defined $_->[0] } @workers;
            if($free_worker) {
                $free_worker->[0] = $step;
                $free_worker->[1] = step_duration($step);
                $in_work{$step} = 1;
            }
        }

        # work and done
        for my $w (@workers) {
            if(defined $w->[0]) {
                if(--$w->[1] == 0) {
                    $result .= $w->[0];
                    $done{ $w->[0] } = 1;
                    undef $w->[0], $w->[1];
                }
            }
        }

        $second++;
    }

    return { result => $result, time => $second };
}

sub step_duration {
    my ($step) = @_;
    return 61 + ord($step) - ord('A');
}

=head1 ASSIGNMENT

https://adventofcode.com/2018/day/7

=head2 --- Day 7: The Sum of Its Parts ---

You find yourself standing on a snow-covered coastline; apparently, you landed
a little off course. The region is too hilly to see the North Pole from here,
but you do spot some Elves that seem to be trying to unpack something that
washed ashore. It's quite cold out, so you decide to risk creating a paradox by
asking them for directions.

"Oh, are you the search party?" Somehow, you can understand whatever Elves from
the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the device on
your wrist also be a translator? "Those clothes don't look very warm; take
this." They hand you a heavy coat.

"We do need to find our way back to the North Pole, but we have higher
priorities at the moment. You see, believe it or not, this box contains
something that will solve all of Santa's transportation problems - at least,
that's what it looks like from the pictures in the instructions." It doesn't
seem like they can read whatever language it's in, but you can: "Sleigh kit.
Some assembly required."

"'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at
once!" They start excitedly pulling more parts out of the box.

The instructions specify a series of steps and requirements about which steps
must be finished before others can begin (your puzzle input). Each step is
designated by a single letter. For example, suppose you have the following
instructions:

    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.

Visually, these requirements look like this:


      -->A--->B--
     /    \      \
    C      -->D----->E
     \           /
      ---->F-----

Your first goal is to determine the order in which the steps should be
completed. If more than one step is ready, choose the step which is first
alphabetically. In this example, the steps would be completed as follows:

    Only C is available, and so it is done first.
    Next, both A and F are available. A is first alphabetically, so it is done next.
    Then, even though F was available earlier, steps B and D are now also available,
        and B is the first alphabetically of the three.
    After that, only D and F are available. E is not available because only
        some of its prerequisites are complete. Therefore, D is completed next.
    F is the only choice, so it is done next.
    Finally, E is completed.

So, in this example, the correct order is CABDFE.

In what order should the steps in your instructions be completed?

Your puzzle answer was EBICGKQOVMYZJAWRDPXFSUTNLH.

=head2 --- Part Two ---

As you're about to begin construction, four of the Elves offer to help. "The
sun will set soon; it'll go faster if we work together." Now, you need to
account for multiple people working on steps simultaneously. If multiple steps
are available, workers should still begin them in alphabetical order.

Each step takes 60 seconds plus an amount corresponding to its letter: A=1,
B=2, C=3, and so on. So, step A takes 60+1=61 seconds, while step Z takes
60+26=86 seconds. No time is required between steps.

To simplify things for the example, however, suppose you only have help from
one Elf (a total of two workers) and that each step takes 60 fewer seconds (so
that step A takes 1 second and step Z takes 26 seconds). Then, using the same
instructions as above, this is how each second would be spent:

    Second   Worker 1   Worker 2   Done
       0        C          .
       1        C          .
       2        C          .
       3        A          F       C
       4        B          F       CA
       5        B          F       CA
       6        D          F       CAB
       7        D          F       CAB
       8        D          F       CAB
       9        D          .       CABF
      10        E          .       CABFD
      11        E          .       CABFD
      12        E          .       CABFD
      13        E          .       CABFD
      14        E          .       CABFD
      15        .          .       CABFDE

Each row represents one second of time. The Second column identifies how many
seconds have passed as of the beginning of that second. Each worker column
shows the step that worker is currently doing (or . if they are idle). The Done
column shows completed steps.

Note that the order of the steps has changed; this is because steps now take
time to finish and multiple workers can begin multiple steps simultaneously.

In this example, it would take 15 seconds for two workers to complete these steps.

With 5 workers and the 60+ second step durations described above, how long will
it take to complete all of the steps?

Your puzzle answer was 906.

=cut
