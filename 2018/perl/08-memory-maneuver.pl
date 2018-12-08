
use 5.16.3;
use Test::More;
use Path::Class      qw(file);
use List::AllUtils   qw(sum);
use Iterator::Simple qw(iterator list ihead);

my $test = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2';
is sum_meta(input_data($test)),   138, 'part 1 - test';
is root_value(input_data($test)), 66,  'part 2 - test';

my $input_file = "../input/08.txt";
my $input = file($input_file)->slurp(chomp => 1);
is sum_meta(input_data($input)),   36566, 'part 1';
is root_value(input_data($input)), 30548, 'part 2';

done_testing;


sub input_data {
    my ($line) = @_;
    return iterator {
        return $1 if $line =~ s/^(\d+)\s*//;
        return;
    };
}

sub reduce_tree {
    my ($cb, $iter) = @_;

    # read header
    my $num_nodes = $iter->next;
    my $num_meta  = $iter->next;

    my @nodes;
    push @nodes, reduce_tree($cb, $iter) for 1 .. $num_nodes;
    return $cb->(\@nodes, list ihead($num_meta, $iter));
}

sub sum_meta {
    my ($iter) = @_;
    return reduce_tree(sub { my ($nodes, $meta) = @_; return sum @$nodes, @$meta }, $iter);
}

sub root_value {
    my ($iter) = @_;
    return reduce_tree(sub {
        my ($nodes, $meta) = @_;
        return sum @$meta if @$nodes == 0;
        return sum map { $nodes->[$_-1]//0 } @$meta;
    }, $iter);
}
