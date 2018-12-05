
use 5.16.3;
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(min_by);
use Data::Dump;

my $test_input = 'dabAcCaCBAcCcaDA';

is reduce_polymer($test_input), 'dabCBAcaDA', 'part 1 - test';
is length reduce_polymer($test_input), 10, 'part 1 - test length';

my $input_file = "../input/05.txt";
my $input = file($input_file)->slurp(chomp => 1);
is length reduce_polymer($input), 9370, 'part 1';

# simple brute force, maybe look for better solution
my $min_removed = min_by { length reduce_polymer(remove_polymer($input, $_)) } 'a'..'z';
is length reduce_polymer(remove_polymer($input, $min_removed)), 6390, 'part 2';

done_testing;


sub reduce_polymer {
    my ($input) = @_;

    my $re = join '|', map { (lc($_).uc($_), uc($_).lc($_)) } 'a'..'z';
    1 while $input =~ s/$re//g;
    return $input;
}

sub remove_polymer {
    my ($input, $poly) = @_;

    $input =~ s/$poly//gi;
    return $input;
}
