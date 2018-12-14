
package Pots;
use Moo;
use Function::Parameters;
use List::AllUtils qw(sum);
use Data::Dump qw(pp);

has plants_in => (is => 'rwp', default => sub { [] });
has rules     => (is => 'ro',  default => sub { [] });

method new_from_string($class: $input) {
    my @plants_in;
    my @rules = (0)x32;
    for my $line (split /\n/, $input) {
        if(my ($string) = $line =~ /initial state: ([#.]+)/) {
            @plants_in = grep { substr($string, $_, 1) eq '#' } 0 .. length($string) - 1;
        }
        if(my ($rule, $result) = $line =~ /([#.]+) => ([#.])/) {
            # convert rule to number 0..31
            $rule =~ tr/#./10/;
            $rules[ oct "0b$rule" ] = $result eq "#" ? 1 : 0;
        }
    }
    $class->new(plants_in => \@plants_in, rules => \@rules);
}

method grow_generation() {
    my $i = 0;
    my $pot = $self->plants_in->[$i] - 5;
    my $state = 0;
    my @result = ();
    while($pot <= $self->plants_in->[-1]) {
        # warn sprintf "gg: %d %05b %d[%d] %s\n", $pot, $state, $i, $self->plants_in->[$i], pp(\@result);
        if($self->rules->[$state]) {
            push @result, $pot + 2;
        }
        $pot++;
        $state = ($state << 1) & 0x1F;
        if(defined $self->plants_in->[$i] && $pot + 4 == $self->plants_in->[$i]) {
            $state |= 1;
            $i++;
        }
    }
    $self->_set_plants_in(\@result);
}

method to_string($gen, $from, $to) {
    my $str = "." x ($to - $from);
    for my $i (@{ $self->plants_in }) {
        substr($str, $i-$from, 1, "#");
    }
    return sprintf "%2d: %s", $gen, $str;
}

method num_pots() {
    return scalar @{ $self->plants_in };
}

method sum_pots() {
    return sum @{ $self->plants_in };
}

1;

=head1 NAME

Pots - cave with plant pots

=head1 SYNOPSIS

    use Pots;

    my $pots->new_from_string($input);


=head1 DESCRIPTION

??

=head1 CONSTRUCTOR

=head1 METHODS

??

=cut
