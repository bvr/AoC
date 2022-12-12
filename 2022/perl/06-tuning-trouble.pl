
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);

my $input_file = "../input/06.txt";
my $comm = file($input_file)->slurp(chomp => 1);
my %tests = (
    'mjqjpqmgbljsphdztnvjfqwrcgsmlb' => 7,
    'bvwbjplbgvbhsrlpgdmjqwftvncz' => 5,
    'nppdvjthqldpwncqszvftbrmjlhg' => 6,
    'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg' => 10,
    'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw' => 11,
);

for my $test_string (sort keys %tests) {
    is find_marker($test_string, 4), $tests{$test_string}, "test - marker of $test_string at $tests{$test_string}";
}

is find_marker($comm, 4), 1625, 'part 1';

my %tests2 = (
    'mjqjpqmgbljsphdztnvjfqwrcgsmlb' => 19,
    'bvwbjplbgvbhsrlpgdmjqwftvncz' => 23,
    'nppdvjthqldpwncqszvftbrmjlhg' => 23,
    'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg' => 29,
    'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw' => 26,
);

for my $test_string (sort keys %tests2) {
    is find_marker($test_string, 14), $tests2{$test_string}, "test 2 - marker of $test_string at $tests{$test_string}";
}

is find_marker($comm, 14), 2250, 'part 2';


done_testing;

sub find_marker {
    my ($input, $marker_length) = @_;

    my $pos = $marker_length - 1;
    while($pos < length($input)) {
        return $pos+1 if is_marker(substr($input, $pos - $marker_length + 1, $marker_length));
        $pos++;
    }

    return 0;
}

sub is_marker {
    my ($segment) = @_;

    my %counts = ();
    $counts{$_}++ for split //, $segment;
    return (sort values %counts)[-1] == 1;
}
