
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

my $test_rules = build_rules(\@test_data);
my $rules      = build_rules(\@data);

is middle_pages_for_correct($test_rules, \@test_data), 143,  'part 1 - test';
is middle_pages_for_correct($rules, \@data),           5639, 'part 1 - real';

is middle_pages_for_incorrect_sorted($test_rules, \@test_data), 123,  'part 2 - test';
is middle_pages_for_incorrect_sorted($rules, \@data),           5273, 'part 2 - real';

done_testing;

fun build_rules($data) {
    my %rules = ();
    for my $line (@$data) {
        next unless $line =~ /^(\d+)\|(\d+)$/;
        $rules{$1}{$2} = 1;
    }
    return \%rules;
}

fun middle_pages_for_correct($rules, $data) {
    my $sum_middle_pages = 0;
    for my $update (grep { /,/ } @$data) {
        my @pages = split /,/, $update;
        if(check_rules($rules, @pages)) {
            $sum_middle_pages += $pages[$#pages/2];
        }
    }
    return $sum_middle_pages;
}

fun middle_pages_for_incorrect_sorted($rules, $data) {
    my $sum_middle_pages = 0;
    for my $update (grep { /,/ } @$data) {
        my @pages = split /,/, $update;
        if(! check_rules($rules, @pages)) {
            my @sorted_pages = sort { defined $rules->{$a}{$b} ? -1 : defined $rules->{$b}{$a} ? 1 : 0 } @pages;
            $sum_middle_pages += $sorted_pages[$#sorted_pages/2];
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
