
use 5.16.3;
package CollectionArea;
use Moo;
use Types::Standard qw(ArrayRef Str);
use Function::Parameters;

has area => (is => 'ro', isa => ArrayRef[ArrayRef[Str]]);
has size => (is => 'lazy');

method new_from_string($class: $str) {
    $class->new(area => [ map { [ split // ] } split /\n/, $str ]);
}

method _build_size {
    return scalar @{ $self->area };
}

method count_adjacent($r, $c) {
    my ($tree, $lumb) = (0, 0);
    for my $dr (-1..1) {
        for my $dc (-1..1) {
            next if $dr == 0 && $dc == 0;
            my $acre = $self->cell($r + $dr, $c + $dc);
            next unless $acre;
            $tree++ if $acre eq '|';
            $lumb++ if $acre eq '#';
        }
    }
    return ($tree, $lumb);
}

method cell($r, $c) {
    return undef if $r < 0            || $c < 0;
    return undef if $r >= $self->size || $c >= $self->size;
    return $self->area->[$r][$c];
}

method new_generation {
    my $new_array = [];
    for my $r (0 .. $self->size - 1) {
        for my $c (0 .. $self->size - 1) {
            my $acre = $self->cell($r, $c);
            my ($t, $l) = $self->count_adjacent($r, $c);

            $new_array->[$r][$c] = $acre;
            if($acre eq '.') {
                $new_array->[$r][$c] = '|' if $t >= 3;
            }
            elsif($acre eq '|') {
                $new_array->[$r][$c] = '#' if $l >= 3;
            }
            elsif($acre eq '#') {
                $new_array->[$r][$c] = '.' if $t < 1 || $l < 1;
            }
        }
    }
    return CollectionArea->new(area => $new_array);
}

method resource_value {
    my ($tree, $lumb) = (0, 0);
    for my $r (0 .. $self->size - 1) {
        for my $c (0 .. $self->size - 1) {
            my $acre = $self->cell($r, $c);
            $tree++ if $acre eq '|';
            $lumb++ if $acre eq '#';
        }
    }
    return $tree * $lumb;
}

method to_string {
    return join("\n", map { join '', @$_ } @{ $self->area }) . "\n";
}

1;
