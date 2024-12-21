package Grid;
use Moo;
use Types::Standard qw(Int Str HashRef ArrayRef InstanceOf);
use Function::Parameters;

use Point;

has area => (is => 'ro', isa => ArrayRef[Str]);
has freq => (is => 'ro', isa => HashRef[ArrayRef[InstanceOf['Point']]]);

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

method at($pos) {
    return '' if $pos->x < 0 || $pos->y < 0;
    return '' if $pos->x > length($self->area->[$pos->y] // '');
    return substr($self->area->[$pos->y] // '', $pos->x, 1);
}

1;
