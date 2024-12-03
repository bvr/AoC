
# solution to https://adventofcode.com/2024/day/2

use Test2::V0;
use Path::Class qw(file);
use List::AllUtils qw(true);
use Function::Parameters;
use Data::Dump qw(dd pp);

my @test_data = (
    [qw(7 6 4 2 1)],
    [qw(1 2 7 8 9)],
    [qw(9 7 6 2 1)],
    [qw(1 3 2 4 5)],
    [qw(8 6 4 4 1)],
    [qw(1 3 6 7 9)],
);

my $input_file = "../input/02.txt";
my @data = map { +[ split /\s+/ ] } file($input_file)->slurp(chomp => 1);

# for my $row (@test_data) {
#     warn pp($row), " => ", is_safe_w_tolerance(@$row) ? "safe" : "unsafe", "\n";
# }

is( (true { is_safe(@$_) } @test_data),   2, 'part 1 - test data');
is( (true { is_safe(@$_) } @data),      287, 'part 1 - real data');

is( (true { is_safe_w_tolerance(@$_) } @test_data),   4, 'part 2 - test data');
is( (true { is_safe_w_tolerance(@$_) } @data),      354, 'part 2 - real data');

done_testing;

fun is_safe(@report) {
    my $first = shift @report;
    my $second = shift @report;

    return if $first == $second;

    my $diff = abs($first - $second);
    return if $diff > 3;

    if($first > $second) { return check_down($second, @report); }
    else                 { return check_up(  $second, @report); }
}

fun check_down($lead, @rest) {
    return 1 if @rest == 0;

    my $second = shift @rest;
    return if $lead <= $second;
    return if $lead - $second > 3;
    return check_down($second, @rest);
}

fun check_up($lead, @rest) {
    return 1 if @rest == 0;
    
    my $second = shift @rest;
    return if $lead >= $second;
    return if $second - $lead > 3;
    return check_up($second, @rest);
}

fun is_safe_w_tolerance(@report) {
    return 1 if is_safe(@report);
    for my $i (0 .. $#report) {
        my @report_damped = map { $_ != $i ? ($report[$_]) : () } 0 .. $#report;
        return 1 if is_safe(@report_damped);
    }
    return 0;
}
