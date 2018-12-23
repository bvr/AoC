
use 5.16.3;
use lib 'lib';
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(sum max_by min_by minmax min max all any zip pairmap);
use Array::Utils   qw(intersect);
use Data::Dump     qw(dd pp);

package Bot {
    use Moo;
    use Function::Parameters;
    use List::AllUtils qw(sum minmax min max reduce);
    use Data::Dump;

    has pos => (is => 'ro');
    has rad => (is => 'ro');

    method in_range($b) {
        return $self->man_dist_to($b) <= $self->rad;
    }

    method man_dist_to($b) {
        return sum map { abs($self->pos->[$_] - $b->pos->[$_]) } 0..2;
    }

    method has_common_range_with($b) {
        return $self->man_dist_to($b) <= $self->rad + $b->rad;
    }

    method moves($by) {
        my @dirs = ();
        for my $dx (-1, 0, 1) {
            for my $dy (-1, 0, 1) {
                for my $dz (-1, 0, 1) {
                    next if $dx == 0 && $dy == 0 && $dz == 0;
                    push @dirs, [$dx * $by, $dy * $by, $dz * $by];
                }
            }
        }
        return map {
            my ($dx, $dy, $dz) = @$_;
            Bot->new(pos => [ $self->pos->[0] + $dx, $self->pos->[1] + $dy, $self->pos->[2] + $dz ])
        } @dirs;
    }

}

my $input_file = "../input/23.txt";
my @input = file($input_file)->slurp(chomp => 1);

my @test_input = split /\n/, <<END;
pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
END

my @bots = map {
    my ($x, $y, $z, $r) = /pos=<([+-]?\d+),([+-]?\d+),([+-]?\d+)>, r=(\d+)/;
    Bot->new(pos => [$x,$y,$z], rad => $r)
} @input;

my $max_radius_bot = max_by { $_->rad } @bots;

my @in_range = grep { $max_radius_bot->in_range($_) } @bots;
is scalar @in_range, 580, 'part 1';

my @groups;
for my $from (sort { $b->rad <=> $a->rad } @bots) {
    push @groups, [$from];
    for my $to (@bots) {
        next if $from == $to;
        push @{ $groups[-1] }, $to if $from->has_common_range_with($to);
    }
}

my @isect = @bots;
my $i = 1;
for my $grp (sort { @$b <=> @$a } @groups) {
    my @is = intersect(@isect, @$grp);
    # warn $i,": ", scalar @is, "\n";
    last if $i == scalar @is;
    @isect = @is;
    $i++;
}

# center
my $x = int(sum(map { $_->pos->[0] } @isect) / @isect);
my $y = int(sum(map { $_->pos->[1] } @isect) / @isect);
my $z = int(sum(map { $_->pos->[2] } @isect) / @isect);
# my $center = Bot->new(pos => [$x, $y, $z]);


# my $step = 1024**2;
# dd find_best_position($center, $step);

my $fine_tune = Bot->new(pos => [13839441, 57977301, 25999489]);
is sum(@{ find_best_position($fine_tune, 1)->pos }), 97816347, 'part 2';;




sub find_best_position {
    my ($center, $step) = @_;

    return if $step == 0;

    my @distances = map { $_->rad - $_->man_dist_to($center) } @isect;

    dd $center, $step;
    # dd \@distances;

    return $center if all { $_ >= 0 } @distances;

    # dd $center, $step;

    my $good = 0;
    for my $new ($center->moves($step)) {
        my @new_dist = map { $_->rad - $_->man_dist_to($new) } @isect;
        # dd [pairmap { [$a, $b, $b == 0 ? 1 : $a < 0 ? $a < $b : $b ] } zip @distances, @new_dist ];
        my $good_direction = all { $_ } pairmap { $b == 0 ? 1 : $a < 0 ? $a < $b : $b } zip @distances, @new_dist;
        # warn "good_direction = $good_direction\n";
        if($good_direction) {
            $good++;
            my $found = find_best_position($new, $step);
            return $found if $found;
        }
    }

    if($good == 0) {
        return find_best_position($center, int($step / 2));
    }
}


done_testing;


=head1 ASSIGNMENT

https://adventofcode.com/2018/day/23

=head2 ??

=cut

