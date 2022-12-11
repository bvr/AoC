use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum natatime first);

my $input_file = "../input/05.txt";
my @items = file($input_file)->slurp(chomp => 1);



done_testing;