
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::Util qw(sum);

my $input_file = "../input/02.txt";
my @guide = file($input_file)->slurp(chomp => 1);

my @test_guide = (
    "A Y",
    "B X",
    "C Z",
);

my %results_game_1 = (
    "A X" => 1 + 3,         # Rock Rock -> Draw
    "A Y" => 2 + 6,         # Rock Paper -> Win
    "A Z" => 3 + 0,         # Rock Scissors -> Lose

    "B X" => 1 + 0,         # Paper Rock -> Lose
    "B Y" => 2 + 3,         # Paper Paper -> Draw
    "B Z" => 3 + 6,         # Paper Scissors -> Win

    "C X" => 1 + 6,         # Scissors Rock -> Win
    "C Y" => 2 + 0,         # Scissors Paper -> Lose
    "C Z" => 3 + 3,         # Scissors Scissors -> Draw
);

my %results_game_2 = (
    "A X" => 3 + 0,         # Rock Lose -> Scissors
    "A Y" => 1 + 3,         # Rock Draw -> Rock
    "A Z" => 2 + 6,         # Rock Win -> Paper

    "B X" => 1 + 0,         # Paper Lose -> Rock
    "B Y" => 2 + 3,         # Paper Draw -> Paper
    "B Z" => 3 + 6,         # Paper Win -> Scissors

    "C X" => 2 + 0,         # Scissors Lose -> Paper
    "C Y" => 3 + 3,         # Scissors Draw -> Scissors
    "C Z" => 1 + 6,         # Scissors Win -> Rock
);


is score_game(\@test_guide, \%results_game_1), 15,    'test game';
is score_game(\@guide,      \%results_game_1), 9651,  'part 1';
is score_game(\@test_guide, \%results_game_2), 12,    'test game part 2';
is score_game(\@guide,      \%results_game_2), 10560, 'part 2';

done_testing;

sub score_game {
    my ($guide, $results) = @_;

    return sum map { $results->{$_} } @$guide;
}
