package Map;
use Moo;
use MooX::StrictConstructor;
use Types::Standard qw(Int Str Enum ArrayRef InstanceOf);
use List::AllUtils qw(max);
use Function::Parameters;
use Iterator::Simple qw(iterator);
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

method number_cycles_iterator() {
    my $cycles = 0;
    my $it = $self->walk_iterator($self->start, Direction->up(), fun($pos) { $self->at($pos) eq '#' });

    my $step = 0;

    my %already_there = ();
    while(my ($pos, $dir) = $it->next) {
        warn $step++ . " - cycles=" . $cycles . "\n";
        my $obstacle = $pos->offset($dir);
        if($self->is_walk_cycle2($pos, $dir, $obstacle, { %already_there })) {
            $cycles++;
        }

        my $state = $pos->to_string() . '-' . $dir->to_string();
        $already_there{ $state } = 1;
    }
    return $cycles;
}

method is_walk_cycle2($pos, $dir, $obstacle, $already_there) {
    my $finish_walk = $self->walk_iterator($pos, $dir, fun($pos) { $self->at($pos) eq '#' || $pos->equals($obstacle) });
    while(my ($pos, $dir) = $finish_walk->next) {
        my $state = $pos->to_string() . '-' . $dir->to_string();
        return 1 if defined $already_there->{ $state };
        $already_there->{ $state } = 1;
    }
    return 0;
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

method number_steps_iterator() {
    my $it = $self->walk_iterator($self->start, Direction->up(), fun($pos) { $self->at($pos) eq '#' });
    my %unique_pos = ();
    while(my ($pos) = $it->next) {
        $unique_pos{ $pos->to_string() } = 1;
    }
    return scalar keys %unique_pos;
}

method walk_iterator($pos, $dir, $blocked) {
    return iterator {
        return if $self->at($pos) eq '';
        my $prev_pos = $pos;
        my $prev_dir = $dir;

        $dir = $dir->clockwise() while $blocked->($pos->offset($dir));
        $pos = $pos->offset($dir);
        return ($prev_pos, $prev_dir);
    };
}

method at($pos) {
    return '' if $pos->x < 0 || $pos->y < 0;
    return '' if $pos->x > length($self->area->[$pos->y] // '');
    return substr($self->area->[$pos->y] // '', $pos->x, 1);
}

1;
