
# solution to https://adventofcode.com/2024/day/5

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use List::AllUtils qw(sum natatime first);
use Data::Dump qw(dd pp);

my $input_file = "../input/05.txt";
my @data = file($input_file)->slurp(chomp => 1);

my @test_data = split /\n/, <<END;
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
END

my $rules = build_rules(\@test_data);
is middle_pages($rules, \@test_data), 143, 'part 1 - test';

done_testing;

fun build_rules($data) {
    my %rules = ();
    for my $line (@$data) {
        next unless $line =~ /^(\d+)\|(\d+)$/;
        $rules{$1}{$2} = 1;
    }
    return \%rules;
}

fun middle_pages($rules, $data) {
    my $sum_middle_pages = 0;
    for my $update (grep { /,/ } @$data) {
        my @pages = split /,/, $update;
        if(check_rules($rules, @pages)) {
            $sum_middle_pages += $pages[$#pages/2];
        }
    }
    return $sum_middle_pages;
}

fun check_rules($rules, @pages) {
    for my $i (1 .. $#pages) {
        for my $j (0 .. $i-1) {
            return 0 unless $rules->{ $pages[$j] }{ $pages[$i] };
        }
    }
    return 1;
}
