
use 5.16.3;
use Test::More;
use Path::Class    qw(file);
use List::AllUtils qw(minmax);
use Data::Dump     qw(pp dd);

my $input_file = "../input/10.txt";
move_stars(load_stars(file($input_file)));

done_testing;

sub load_stars {
    my ($file) = @_;

    my $fh = $file->openr;

    my @stars;
    while(<$fh>) {
        if(/position=<(.*?)> velocity=<(.*?)>/) {
            push @stars, {
                pos => [ map { int } split /,/, $1 ],
                vel => [ map { int } split /,/, $2 ],
            };
        }
    }
    return \@stars;
}

sub move_stars {
    my @stars = eval pp @{$_[0]};

    my $last_area;
    my $count = 0;
    while(1) {
        for my $s (@stars) {
            next unless defined $s;
            $s->{pos}[$_] += $s->{vel}[$_] for 0..1;
        }

        # calculate bounding box
        my ($minx, $maxx) = minmax map { $_->{pos}[0] } @stars;
        my ($miny, $maxy) = minmax map { $_->{pos}[1] } @stars;

        my $area = ($maxx - $minx) * ($maxy - $miny);
        if($last_area && $last_area < $area) {
            # we should stop and step back
            for my $s (@stars) {
                next unless defined $s;
                $s->{pos}[$_] -= $s->{vel}[$_] for 0..1;
            }

            print "$count\n";
            print_stars(\@stars);
            return;
        }

        $last_area = $area;
        $count++;
    }
}

sub print_stars {
    my ($stars) = @_;

    my ($minx, $maxx) = minmax map { $_->{pos}[0] } @$stars;
    my ($miny, $maxy) = minmax map { $_->{pos}[1] } @$stars;

    my @display = map { " " x ($maxx - $minx) } $miny .. $maxy;
    for my $s (@$stars) {
        substr($display[$s->{pos}[1] - $miny], $s->{pos}[0] - $minx, 1, '*');
    }
    say for @display;
}




=head1 ASSIGNMENT

https://adventofcode.com/2018/day/10

=cut
