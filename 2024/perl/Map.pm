package Map;
use Moo;
use MooX::StrictConstructor;
use Types::Standard qw(Int Str Enum ArrayRef InstanceOf);
use List::AllUtils qw(max);
use Function::Parameters;
use Data::Dump qw(dd pp);

use Point;
use Direction;

has area  => (is => 'ro', isa => ArrayRef[Str]);
has start => (is => 'ro', isa => InstanceOf['Point']);

method from_string($class: $map_data) {
    return $class->new(area => $map_data, start => _find_guard_in($map_data));
}

fun _find_guard_in($area) {
    for my $y (0 .. $#$area) {
        my $x = index($area->[$y], '^');
        return Point->new(x => $x, y => $y) if $x >= 0;
    }
    die "Could not find guard position in supplied map";
}

method number_cycles() {
    my $cycles = 0;
    my $steps = $self->guard_walk();
    # dd $steps;

    my $progress = 0;
    for my $obstacle_pos (values %$steps) {
        warn $progress++." / ".(scalar values %$steps)." cycles = $cycles\n";
        if($self->is_walk_cycle($obstacle_pos)) {
            $cycles++;
            warn pp($obstacle_pos);
        }
    }
    return $cycles;
}

method is_walk_cycle($obstacle) {
    my $pos = $self->start;
    my $dir = Direction->up();

    return if $pos->equals($obstacle);      # the obstacle cannot be at the guard pos

    my %already_there = ();
    while(1) {
        my $state = $pos->to_string() . '-' . $dir->to_string();
        return 1 if defined $already_there{ $state };
        $already_there{ $state } = 1;

        $dir = $dir->clockwise() while $self->at($pos->offset($dir)) eq '#' || $pos->offset($dir)->equals($obstacle);
        $pos = $pos->offset($dir);
        return if $self->at($pos) eq '';
    }
}

method number_steps() {
    return scalar keys(%{ $self->guard_walk() });
}

method guard_walk() {
    my $pos = $self->start;
    my $dir = Direction->up();

    my %unique_pos = ();
    while(1) {
        $unique_pos{ $pos->to_string() } = $pos;
        $dir = $dir->clockwise() while $self->at($pos->offset($dir)) eq '#';
        $pos = $pos->offset($dir);
        last if $self->at($pos) eq '';
    }
    return \%unique_pos;
}

method at($pos) {
    return '' if $pos->x < 0 || $pos->y < 0;
    return '' if $pos->x > length($self->area->[$pos->y] // '');
    return substr($self->area->[$pos->y] // '', $pos->x, 1);
}

1;
