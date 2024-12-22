package Point;
use Moo;
use Types::Standard qw(Int);
use Function::Parameters;
use namespace::clean;
use MooX::StrictConstructor;

use Direction;

has x => (is => 'ro', isa => Int, required => 1);
has y => (is => 'ro', isa => Int, required => 1);

method offset($dir) {
    return Point->new(
        x => $self->x + $dir->dx, 
        y => $self->y + $dir->dy
    );
}

method equals($point) {
    return $self->x == $point->x 
        && $self->y == $point->y;
}

method dir_to($point) {
    return Direction->new(
        dx => $point->x - $self->x, 
        dy => $point->y - $self->y
    );
}

method to_string() {
    return join ',', $self->x, $self->y;
}

1;
