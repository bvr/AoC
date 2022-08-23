
use 5.16.3;
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw();
use Data::Dump;

my $input_file = "../input/03.txt";
my @input = file($input_file)->slurp(chomp => 1);



done_testing;
