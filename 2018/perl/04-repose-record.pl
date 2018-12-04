
use 5.16.3;
use Test::More;
use Path::Class      qw(file);
use List::AllUtils   qw(sum max max_by);
use Data::Dump;

my @test_items = split /\n/, <<END;
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
END

is find_good_time(parse_input(\@test_items))->[0], 240, 'part 1 - test';

my $input_file = "../input/04.txt";
my @data_items = file($input_file)->slurp(chomp => 1);

my $result = find_good_time(parse_input(\@data_items));
is $result->[0], 67558, 'part 1';
is $result->[1], 78990, 'part 2';

done_testing;

sub parse_input {
    my ($lines) = @_;

    # build structure like:  $asleep->{$day}{$guard_id}[$minute] = 1
    my $asleep = {};
    my $curr_guard_id;
    my $falls_asleep;
    for my $line (sort @$lines) {
        if(my ($day, $min) = $line =~ /\[\d+-(\d+-\d+) \d+:(\d+)\]/) {
            if($line =~ /Guard #(\d+) begins shift/) {
                $curr_guard_id = $1;
            }
            if($line =~ /falls asleep/) {
                $falls_asleep = $min;
            }
            if($line =~ /wakes up/) {
                $asleep->{$day}{$curr_guard_id}[$_] = 1  for $falls_asleep .. $min-1;
                undef $falls_asleep;
            }
        }
    }

    return $asleep;
}

sub find_good_time {
    my ($asleep) = @_;

    # $guards{$guard_id}[$minute]
    my %guards = ();
    for my $day (keys %$asleep) {
        for my $guard_id (keys %{ $asleep->{$day} }) {
            for my $min (0 .. 59) {
                $guards{$guard_id}[$min]++ if $asleep->{$day}{$guard_id}[$min] == 1;
            }
        }
    }

    # strategy 1 - elf that sleeps most
    my $most_sleepy_id = max_by { sum @{$guards{$_}}              } keys %guards;
    my $worst_minute   = max_by { $guards{$most_sleepy_id}[$_]//0 } 0 .. 59;

    # strategy 2 - elf that slept most times in specific minute
    my $most_times_id  = max_by { max @{$guards{$_}}              } keys %guards;
    my $most_times_min = max_by { $guards{$most_times_id}[$_]//0  } 0 .. 59;

    return [ $most_sleepy_id * $worst_minute, $most_times_id * $most_times_min ];
}

=head1 ASSIGNMENT

https://adventofcode.com/2018/day/4

=head2 --- Day 4: Repose Record ---

You've sneaked into another supply closet - this time, it's across from the
prototype suit manufacturing lab. You need to sneak inside and fix the issues
with the suit, but there's a guard stationed outside the lab, so this is as
close as you can safely get.

As you search the closet for anything that might help, you discover that you're
not the first person to want to sneak in. Covering the walls, someone has spent
an hour starting every midnight for the past few months secretly observing this
guard post! They've been writing down the ID of the one guard on duty that
night - the Elves seem to have decided that one guard was enough for the
overnight shift - as well as when they fall asleep or wake up while at their
post (your puzzle input).

For example, consider the following records, which have already been organized
into chronological order:

    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up

Timestamps are written using year-month-day hour:minute format. The guard
falling asleep or waking up is always the one whose shift most recently
started. Because all asleep/awake times are during the midnight hour (00:00 -
00:59), only the minute portion (00 - 59) is relevant for those events.

Visually, these records show that the guards are asleep at these times:

    Date   ID   Minute
                000000000011111111112222222222333333333344444444445555555555
                012345678901234567890123456789012345678901234567890123456789
    11-01  #10  .....####################.....#########################.....
    11-02  #99  ........................................##########..........
    11-03  #10  ........................#####...............................
    11-04  #99  ....................................##########..............
    11-05  #99  .............................................##########.....

The columns are Date, which shows the month-day portion of the relevant day;
ID, which shows the guard on duty that day; and Minute, which shows the minutes
during which the guard was asleep within the midnight hour. (The Minute
column's header shows the minute's ten's digit in the first row and the one's
digit in the second row.) Awake is shown as ., and asleep is shown as #.

Note that guards count as asleep on the minute they fall asleep, and they count
as awake on the minute they wake up. For example, because Guard #10 wakes up at
00:25 on 1518-11-01, minute 25 is marked as awake.

If you can figure out the guard most likely to be asleep at a specific time,
you might be able to trick that guard into working tonight so you can have the
best chance of sneaking in. You have two strategies for choosing the best
guard/minute combination.

Strategy 1: Find the guard that has the most minutes asleep. What minute does
that guard spend asleep the most?

In the example above, Guard #10 spent the most minutes asleep, a total of 50
minutes (20+25+5), while Guard #99 only slept for a total of 30
minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days,
whereas any other minute the guard was asleep was only seen on one day).

While this example listed the entries in chronological order, your entries are
in the order you found them. You'll need to organize them before they can be
analyzed.

What is the ID of the guard you chose multiplied by the minute you chose? (In
the above example, the answer would be 10 * 24 = 240.)

Your puzzle answer was 67558.

=head2 --- Part Two ---

Strategy 2: Of all guards, which guard is most frequently asleep on the same
minute?

In the example above, Guard #99 spent minute 45 asleep more than any other
guard or minute - three times in total. (In all other cases, any guard spent
any minute asleep at most twice.)

What is the ID of the guard you chose multiplied by the minute you chose? (In
the above example, the answer would be 99 * 45 = 4455.)

Your puzzle answer was 78990.

=cut
