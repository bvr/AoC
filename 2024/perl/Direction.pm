package Direction;
use Moo;
use Types::Standard qw(Int);
use Function::Parameters;

has dx => (is => 'ro');
has dy => (is => 'ro');

method up($class:) {
    return Direction->new(dx => 0, dy => -1);
}

method clockwise() {
    # 90° clockwise rotation: (x,y) becomes (y,−x) 
    return Direction->new(dx => -$self->dy, dy => $self->dx);
}

1;
