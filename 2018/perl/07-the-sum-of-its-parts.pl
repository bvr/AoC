
use 5.16.3;
use lib 'lib';
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(all sum max max_by first);
use Iterator::Simple qw(list);
use Algorithm::Combinatorics qw(combinations);
use Data::Dump qw(dd pp);

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

    $num_workers ||= 1;

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
        my @avail = sort grep { my $step = $_; all { $done{$_} == 1 } @{$before{$step}} } grep { ! $done{$_} && ! $in_work{$_} } keys %done;

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

=cut

