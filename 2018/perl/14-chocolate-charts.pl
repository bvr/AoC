
use 5.16.3;
use lib 'lib';
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(max);
use Data::Dump qw(dd pp);

my $input = '190221';

my ($e1, $e2) = (0, 1);
my @recipes = (3,7);

while(@recipes < $input + 10) {
    my @new_rec = map { int } split //, $recipes[$e1]+$recipes[$e2];
    push @recipes, @new_rec;
    $e1 = ($e1 + 1 + $recipes[$e1]) % @recipes;
    $e2 = ($e2 + 1 + $recipes[$e2]) % @recipes;
}

my $all_scores = join '', @recipes;
is substr($all_scores, 9,      10), '5158916779', 'part 1 - test';
is substr($all_scores, 5,      10), '0124515891', 'part 1 - test';
is substr($all_scores, 18,     10), '9251071085', 'part 1 - test';
is substr($all_scores, 2018,   10), '5941429882', 'part 1 - test';
is substr($all_scores, $input, 10), '1191216109', 'part 1';

is find('51589'), 9,    'part 2 - test';
is find('01245'), 5,    'part 2 - test';
is find('92510'), 18,   'part 2 - test';
is find('59414'), 2018, 'part 2 - test';
is find($input), 20268576, 'part 2';

done_testing;

sub find {
    my ($input) = @_;
    my ($e1, $e2) = (0, 1);
    my @recipes = (3,7);

    my @dig = split //, $input;
    my $pos = 0;

    my $table = build_table($input);

    while(1) {
        my @new_rec = map { int } split //, $recipes[$e1]+$recipes[$e2];
        for my $n (@new_rec) {
            if($n == $dig[$pos]) {
                $pos++;
                return @recipes - @dig + 1 if $pos == @dig;   # successful match
            }
            else {
                $pos = $table->[$pos];
                redo if defined $pos;
                $pos = 0;
            }
        }
        push @recipes, @new_rec;
        $e1 = ($e1 + 1 + $recipes[$e1]) % @recipes;
        $e2 = ($e2 + 1 + $recipes[$e2]) % @recipes;
    }
}

# https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm
sub build_table {
    my $str = shift;
    my $t = [undef];

    my $pos = 1;
    my $cnd = 0;

    while($pos < length($str)) {
        if(substr($str, $pos, 1) eq substr($str, $cnd, 1)) {
            $t->[$pos] = $t->[$cnd];
        }
        else {
            $t->[$pos] = $cnd;
            $cnd = $t->[$cnd];
            while($cnd && substr($str, $pos, 1) ne substr($str, $cnd, 1)) {
                $cnd = $t->[$cnd];
            }
        }
        $pos++;
        $cnd ||= -1;
        $cnd++;
    }

    return $t;
}


=head1 ASSIGNMENT

https://adventofcode.com/2018/day/14

=head2 ??

=cut

