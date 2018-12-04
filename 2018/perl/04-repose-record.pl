
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use Iterator::Simple qw(iter imap list);
use List::Util qw(sum);
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

{
    my $result = find_good_time(parse_input(\@test_items));
    is $result->{sleepy_id} * $result->{worst_minute}, 240, 'part 1 - test';
}

my $input_file = "../input/04.txt";
my @data_items = file($input_file)->slurp(chomp => 1);

{
    my $result = find_good_time(parse_input(\@data_items));
    is $result->{sleepy_id} * $result->{worst_minute},       67558, 'part 1';
    is $result->{most_times_id} * $result->{most_times_min}, 78990, 'part 2';
}


done_testing;

sub parse_input {
    my ($lines) = @_;

    # build structure like:
    # $asleep->{$day}{$guard_id}[$minute] = 1

    my $asleep = {};
    my $curr_guard_id;
    for my $line (sort @$lines) {
        if(my ($day, $hh, $mm) = $line =~ /\[\d+-(\d+-\d+) (\d+):(\d+)\]/) {
            my $minute = $hh == 23 ? $mm : 60+$mm;

            if(my ($guard_id) = $line =~ /Guard #(\d+) begins shift/) {
                $curr_guard_id = $guard_id;
            }
            if($line =~ /falls asleep/) {
                $asleep->{$day}{$curr_guard_id}[$minute] = 1;
            }
            if($line =~ /wakes up/) {
                my $last_minute = scalar @{ $asleep->{$day}{$curr_guard_id} };
                @{$asleep->{$day}{$curr_guard_id}}[$last_minute .. $minute - 1] = (1) x ($minute - $last_minute);
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
            for my $i (0 .. $#{ $asleep->{$day}{$guard_id} }) {
                $guards{$guard_id}[$i]++ if $asleep->{$day}{$guard_id}[$i] == 1;
            }
        }
    }

    # $total{$guard_id} = minutes asleep
    my %total;
    for my $guard_id (keys %guards) {
        $total{$guard_id} = sum(@{$guards{$guard_id}}[60 .. 119]);
    }

    # strategy 1
    my @sleep_most = sort { $total{$b} <=> $total{$a} } keys %total;
    my $most_sleepy_id = $sleep_most[0];

    my $worst_minute = 0;
    for my $i (0 .. $#{ $guards{$most_sleepy_id} }) {
        if($guards{$most_sleepy_id}[$i] > $guards{$most_sleepy_id}[$worst_minute]) {
            $worst_minute = $i;
        }
    }

    # strategy 2
    my $most_times;
    my $most_times_min;
    my $most_times_id;
    for my $i (60 .. 119) {
        for my $guard_id (keys %guards) {
            if($guards{$guard_id}[$i] > $most_times) {
                $most_times = $guards{$guard_id}[$i];
                $most_times_min = $i;
                $most_times_id = $guard_id;
            }
        }
    }

    return {
        sleepy_id      => $most_sleepy_id,
        worst_minute   => $worst_minute - 60,
        most_times_min => $most_times_min - 60,
        most_times_id  => $most_times_id,
    };
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
