
use 5.16.3;
use lib 'lib';
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(sum max max_by);
use Iterator::Simple qw(list);
use Algorithm::Combinatorics qw(combinations);
use Data::Dump;

package Point {
    use Moo;

    has 'x'    => (is => 'ro');
    has 'y'    => (is => 'ro');
    has 'area' => (is => 'rwp', default => 1);

    sub new_from_array {
        my $class = shift;
        $class->new(x => $_[0], y => $_[1]);
    }

    sub inc_area { my ($self) = @_; $self->_set_area($self->area + 1); }
    sub dec_area { my ($self) = @_; $self->_set_area($self->area - 1); }
}

my $input_file = "../input/06.txt";
my @input = file($input_file)->slurp(chomp => 1);

# dd @input;

my @test = split /\n/, <<END;
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
END

is proc_points(\@test), 17, 'part 1 - test';
# is proc_points(\@input), 4186, 'part 1';
is find_region(\@test, 32), 16, 'part 2 - test';
is find_region(\@input, 10_000), 16, 'part 2';

done_testing;

sub find_region {
    my ($lines, $total_dist) = @_;

    my @points = map { Point->new_from_array(split /,\s*/, $_) } @$lines;

    my $center = Point->new(
        x => int((sum map { $_->x } @points)/@points),
        y => int((sum map { $_->y } @points)/@points),
    );

    # dd $center;
    # warn sum map { man_dist($center, $_) } @points;

    my $dist = 1;
    my $region_size = 1;
    my $added = 1;
    while($added) {
        my @test = points_in_dist($center, $dist);
        $added = grep {
            my $pt = $_;
            sum(map { man_dist($pt, $_) } @points) < $total_dist
        } @test;
        $region_size += $added;
        $dist++;
    }
    return $region_size;
}

sub points_in_dist {
    my ($pt, $d) = @_;

    my @cir = ();
    for my $i (0 .. $d) {

        push @cir, Point->new_from_array($pt->x + $i, $pt->y - $d + $i);
        push @cir, Point->new_from_array($pt->x - $i, $pt->y + $d - $i);

        # skip double updating the corners
        next if $i == 0 || $i == $d;
        push @cir, Point->new_from_array($pt->x + $i, $pt->y + $d - $i);
        push @cir, Point->new_from_array($pt->x - $i, $pt->y - $d + $i);
    }
    return @cir;
}

sub proc_points {
    my ($lines) = @_;

    my @points = map { Point->new_from_array(split /,\s*/, $_) } @$lines;
    my $max_dist = max map { man_dist(@$_) } combinations(\@points, 2);

    warn $max_dist,"\n";

    my %storage = ();
    my $coords = sub {
        my ($x, $y) = @_;
        return $storage{ "$x,$y" } ||= {};
    };

    for my $d (0..$max_dist) {
        for my $pt (@points) {
            my $changed = 0;
            for my $i (0 .. $d) {

                $changed += collide_with($pt, $d, $coords->($pt->x + $i, $pt->y - $d + $i));
                $changed += collide_with($pt, $d, $coords->($pt->x - $i, $pt->y + $d - $i));

                # skip double updating the corners
                next if $i == 0 || $i == $d;
                $changed += collide_with($pt, $d, $coords->($pt->x + $i, $pt->y + $d - $i));
                $changed += collide_with($pt, $d, $coords->($pt->x - $i, $pt->y - $d + $i));
            }
        }
    }
    # dd \%storage;

    my $d = $max_dist + 1;
    my @finite = ();
    for my $pt (@points) {
        my $changed = 0;
        for my $i (0 .. $d) {

            $changed += collide_with($pt, $d, $coords->($pt->x + $i, $pt->y - $d + $i));
            $changed += collide_with($pt, $d, $coords->($pt->x - $i, $pt->y + $d - $i));

            # skip double updating the corners
            next if $i == 0 || $i == $d;
            $changed += collide_with($pt, $d, $coords->($pt->x + $i, $pt->y + $d - $i));
            $changed += collide_with($pt, $d, $coords->($pt->x - $i, $pt->y - $d + $i));
        }
        push @finite, $pt if $changed == 0;
    }

    # dd \@points;

    dd \@finite;

    return (max_by { $_->area } @finite)->area;
}

sub collide_with {
    my ($point, $dist, $place) = @_;

    # new placement
    if(! defined $place->{point}) {
        $place->{point} = $point;
        $place->{dist}  = $dist;
        $point->inc_area;
        return 1;
    }
    else {
        if($place->{dist} == $dist) {
            $place->{point}->dec_area;
        }
        if($place->{dist} > $dist) {
            $place->{point}->dec_area;
            $place->{point} = $point;
            $place->{dist} = $dist;
            $point->inc_area;
            return 1;
        }
    }
    return 0;
}

sub man_dist {
    my ($p1, $p2) = @_;
    return abs($p1->x - $p2->x) + abs($p1->y - $p2->y);
}



=head1 ASSIGNMENT

https://adventofcode.com/2018/day/6

=cut

