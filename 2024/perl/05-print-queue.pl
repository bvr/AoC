
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

my $test = parse_data(\@test_data);
my $real = parse_data(\@data);

is middle_pages_for_correct($test), 143,  'part 1 - test';
is middle_pages_for_correct($real), 5639, 'part 1 - real';

is middle_pages_for_incorrect_sorted($test), 123,  'part 2 - test';
is middle_pages_for_incorrect_sorted($real), 5273, 'part 2 - real';

done_testing;

fun parse_data($data) {
    my %rules = ();
    my @pages = ();
    for my $line (@$data) {
        if($line =~ /^(\d+)\|(\d+)$/) {
            $rules{$1}{$2} = 1;
        }
        if($line =~ /,/) {
            push @pages, [ split /,/, $line ];
        }
    }
    return { rules => \%rules, pages => \@pages };
}

fun middle_pages_for_correct($data) {
    my $sum_middle_pages = 0;
    for my $pages (@{ $data->{pages} }) {
        next unless check_rules($data->{rules}, @$pages);
        $sum_middle_pages += $pages->[$#$pages/2];
    }
    return $sum_middle_pages;
}

fun middle_pages_for_incorrect_sorted($data) {
    my $sum_middle_pages = 0;
    for my $pages (@{ $data->{pages} }) {
        next if check_rules($data->{rules}, @$pages);
        my @sorted_pages = sort { defined $data->{rules}{$a}{$b} ? -1 : defined $data->{rules}{$b}{$a} ? 1 : 0 } @$pages;
        $sum_middle_pages += $sorted_pages[$#sorted_pages/2];
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
