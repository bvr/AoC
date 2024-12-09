package Point;
use Moo;
use Types::Standard qw(Int);
use Function::Parameters;

use Direction;

has x => (is => 'ro', isa => Int);
has y => (is => 'ro', isa => Int);

method offset($dir) {
    return Point->new(x => $self->x + $dir->dx, y => $self->y + $dir->dy);
}

method equals($point) {
    return $self->x == $point->x && $self->y == $point->y;
}

method to_string() {
    return join ',', $self->x, $self->y;
}

1;
