
# solution to https://adventofcode.com/2024/day/4

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use List::AllUtils qw(max sum natatime first);

my $input_file = "../input/04.txt";
my @data = file($input_file)->slurp(chomp => 1);

my @test_data = qw(
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
);

is find_text_count('XMAS', \@test_data), 18,   'part 1 - test';
is find_text_count('XMAS', \@data),      2633, 'part 1 - real';

is find_cross_mas_count(\@test_data),    9,    'part 2 - test';
is find_cross_mas_count(\@data),         1936, 'part 2 - real';

done_testing;

fun find_text_count($text, $data) {
    my $count = 0;
    for my $dir (all_directions($data)) {
        $count += () = $dir =~ /$text/g;
    }
    return $count;
}

fun find_cross_mas_count($data) {
    my ($max_x, $max_y) = get_dimensions($data);
    my $count = 0;
    for my $y (0 .. $max_y-2) {
        for my $x (0 .. $max_x-2) {
            my $center = get_at($data, $x + 1, $y + 1);
            my $lt = get_at($data, $x, $y);
            my $lb = get_at($data, $x, $y + 2);
            my $rt = get_at($data, $x + 2, $y);
            my $rb = get_at($data, $x + 2, $y + 2);
            $count++ if 
                $center eq 'A'
             && (($lt eq 'M' && $rb eq 'S') || ($lt eq 'S' && $rb eq 'M'))
             && (($rt eq 'M' && $lb eq 'S') || ($rt eq 'S' && $lb eq 'M'));
        }
    }
    return $count;
}

fun all_directions($data) {
    my ($max_x, $max_y) = get_dimensions($data);

    my @products = ();
    # rows
    for my $y (0 .. $max_y) {
        push @products, join('', map { get_at($data, $_, $y) } 0 .. $max_x);
        push @products, join('', map { get_at($data, $max_x - $_, $y) } 0 .. $max_x);
    }
    # columns
    for my $x (0 .. $max_x) {
        push @products, join('', map { get_at($data, $x, $_) } 0 .. $max_y);
        push @products, join('', map { get_at($data, $x, $max_y - $_) } 0 .. $max_y);
    }
    # diagonals \
    for my $x (-$max_x .. $max_x) {
        push @products, join('', map { get_at($data, $x + $_, $_) } 0 .. $max_y);
        push @products, join('', map { get_at($data, $x + ($max_y - $_), $max_y - $_) } 0 .. $max_y);
    }
    # diagonals /
    for my $x (0 .. 2 * $max_x) {
        push @products, join('', map { get_at($data, $x - $_, $_) } 0 .. $max_y);
        push @products, join('', map { get_at($data, $x - ($max_y - $_), $max_y - $_) } 0 .. $max_y);
    }

    return @products;
}

fun get_dimensions($data) {
    my $max_y = @$data - 1;
    my $max_x = max(map { length } @$data) - 1;
    return ($max_x, $max_y);
}

fun get_at($data, $x, $y) {
    return '' if $x < 0 || $y < 0;
    return '' if $x > length($data->[$y]);
    return substr($data->[$y], $x, 1);
}
