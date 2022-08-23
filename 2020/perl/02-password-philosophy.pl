
use 5.16.3;
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(sum);
use Data::Dump;

my $input_file = "../input/02.txt";
my @input = file($input_file)->slurp(chomp => 1);

my @test_case = split /\n/, <<END;
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
END

is( (num_valid_passwords(\@test_case))[0], 2, 'test case');
my ($old, $new) = num_valid_passwords(\@input);
is $old, 524, 'part 1';
is $new, 485, 'part 2';


sub num_valid_passwords {
    my ($list) = @_;

    my $ok_cases = 0;
    my $new_cases = 0;
    for my $line (@$list) {
        if(my ($lwr, $upr, $letter, $pwd) = $line =~ /(\d+)-(\d+) (\w+): (.*)/) {
            my $changed = $pwd;
            $changed =~ s/$letter//g;
            my $count = length($pwd) - length($changed);
            # warn "$pwd $letter $lwr <= $count <= $upr: ", ($lwr <= $count && $count <= $upr ? "MATCH" : ""), "\n";
            if($lwr <= $count && $count <= $upr) {
                $ok_cases++;
            }
            $count = sum map { substr($pwd,$_-1,1) eq $letter ? 1 : 0 } ($lwr, $upr);
            if($count == 1) {
                $new_cases++;
            }
        }
        else {
            die "Could not parse the input \"$line\"";
        }
    }
    return ($ok_cases, $new_cases);
}

done_testing;
