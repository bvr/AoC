package Map;
use Moo;
use MooX::StrictConstructor;
use Types::Standard qw(Int Str Enum ArrayRef InstanceOf);
use Function::Parameters;
use Data::Dump qw(dd);

use Point;
use Direction;

has area  => (is => 'ro', isa => ArrayRef[Str]);
has start => (is => 'rwp', isa => InstanceOf['Point']);

method from_string($class: $map_data) {
    my $map = $class->new(area => $map_data);
    $map->_find_guard();
    return $map;
}

method _find_guard() {
    for my $y (0 .. @{ $self->area }-1) {
        my $x = index($self->area->[$y], '^');
        if($x >= 0) {
            $self->_set_start(Point->new(x => $x, y => $y));
            return;
        }
    }
    die "Could not find guard position in supplied map";
}

method guard_walk() {
    my $pos = $self->start;
    my $dir = Direction->up();

    my %unique_pos = ($pos->to_string() => 1);
    while(1) {
        if($self->at($pos->offset($dir)) eq '#') {
            $dir = $dir->clockwise();
        }
        $pos = $pos->offset($dir);
        last if $self->at($pos) eq '';

        $unique_pos{ $pos->to_string() } = 1;
    }
    return scalar keys %unique_pos;
}

method at($pos) {
    return '' if $pos->x < 0 || $pos->y < 0 || $pos->y >= @{ $self->area };
    return '' if $pos->x > length($self->area->[$pos->y]);
    return substr($self->area->[$pos->y], $pos->x, 1);
}

1;