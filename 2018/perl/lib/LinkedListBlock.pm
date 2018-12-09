
package LinkedListBlock;

use Iterator::Simple qw(iterator);

sub new {
    my ($class, $value, $left, $right) = @_;
    my $self = bless [$value], $class;

    if($left) {
        $self->[1] = $left;
        $left->[2] = $self;
    }
    else {
        $self->[1] = $self;
    }

    if($right) {
        $self->[2] = $right;
        $right->[1] = $self;
    }
    else {
        $self->[2] = $self;
    }
    return $self;
}

sub value     { return shift->[0]  }
sub left      { return shift->[1]  }
sub right     { return shift->[2]  }

sub remove {
    my ($self) = @_;

    $self->left->[2]  = $self->right;
    $self->right->[1] = $self->left;

    return $self;
}

sub to_string {
    my ($self, $curr) = @_;

    my $i = $self;
    my $str = '';
    while(1) {
        $str .= $i == $curr ? '('.$i->value.')' : ' '.$i->value.' ';
        $i = $i->right;
        last if $i == $self;
    }
    return $str;
}

1;

=head1 NAME

LinkedListBlock - simple block for double linked list

=head1 SYNOPSIS

    use LinkedListBlock;

    my $curr = LinkedListBlock->new($value);
    my $curr = LinkedListBlock->new($value, $left, $right);

    print $curr->value;

=head1 DESCRIPTION

Arrayref-based class for block of circular doubly linked list.

=head1 CONSTRUCTOR

=head2 new

    LinkedListBlock->new($value);
    LinkedListBlock->new($value, $left, $right);

Builds the block, first variant build item cicular to itself, other
just connect it to other blocks of this type.

=head1 METHODS

=head2 value

Returns value in this block.

=head2 left

Returns block to the left

=head2 right

Returns block to the right

=head2 remove

Unlink this block from its neighbours.

=head2 to_string

    print $block->to_string();
    print $block->to_string($curr);

Returns textual representation of this list, current item marked if specified.

=cut
