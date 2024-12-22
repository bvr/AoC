package Grid;
use Moo;
use Types::Standard qw(Int Str HashRef ArrayRef InstanceOf);
use Function::Parameters;
use Algorithm::Combinatorics qw(combinations);
use namespace::clean;
use MooX::StrictConstructor;

use Point;

has area => (is => 'ro', isa => ArrayRef[Str], required => 1);
has freq => (is => 'ro', isa => HashRef[ArrayRef[InstanceOf['Point']]], required => 1);

method from_string($class: $map_data) {
    return $class->new(area => $map_data, freq => _find_frequencies_in($map_data));
}

fun _find_frequencies_in($area) {
    my %freq = ();
    for my $y (0 .. $#$area) {
        for my $x (0 .. length($area->[$y]) - 1) {
            my $f = substr($area->[$y],$x,1);
            next if $f eq '.';
            $freq{ $f } ||= [];
            push @{ $freq{ $f } }, Point->new(x => $x, y => $y);
        }
    }
    return \%freq;
}

method unique_antinodes($resonance = 0) {
    my %unique = ();
    my $add_node = fun($a) { $unique{ $a->to_string() } = $a if $self->at($a) ne '' };

    for my $f (sort keys %{ $self->freq }) {
        for my $pair (combinations($self->freq->{$f}, 2)) {
            my $dir = $pair->[0]->dir_to($pair->[1]);           # vector between points

            if($resonance) {
                my $a = $pair->[1];
                while($self->at($a) ne '') {
                    $add_node->($a);
                    $a = $a->offset($dir);
                }
                $a = $pair->[0];
                while($self->at($a) ne '') {
                    $add_node->($a);
                    $a = $a->offset($dir->opposite());
                }
            }
            else {
                $add_node->($pair->[1]->offset($dir));
                $add_node->($pair->[0]->offset($dir->opposite()));
            }
        }
    }
    # $self->draw_debug(%unique);
    return () = values %unique;
}

method draw_debug(%unique) {
    for my $y (0 .. $#{$self->area}) {
        my $line = '';
        for my $x (0 .. length($self->area->[$y]) - 1) {
            my $char = $self->at(Point->new(x => $x, y => $y));
            $char = $char eq '.' && $unique{ "$x,$y" } ? '#' : $char;
            $line .= $char;
        }
        print "$line\n";
    }
}

method at($pos) {
    return '' if $pos->x < 0 || $pos->y < 0;
    return '' if $pos->x > length($self->area->[$pos->y] // '');
    return substr($self->area->[$pos->y] // '', $pos->x, 1);
}

1;
