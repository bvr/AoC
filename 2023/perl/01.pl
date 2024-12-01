use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);

my $input_file = "../input/01.txt";
my @items = file($input_file)->slurp(chomp => 1);

my @test = qw(
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
);



done_testing;