
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

fun is_descending(@report) {
    for my $i (0 .. @report - 2) {
        my $diff = $report[$i] - $report[$i + 1];
        return 0 unless $diff >= 1 && $diff <= 3;
    }
    return 1;
}

fun is_safe(@report) {
    return is_descending(@report) || is_descending(reverse @report);
}

fun is_safe_w_tolerance(@report) {
    return 1 if is_safe(@report);
    for my $i (0 .. $#report) {
        my @report_damped = map { $_ != $i ? ($report[$_]) : () } 0 .. $#report;
        return 1 if is_safe(@report_damped);
    }
    return 0;
}
