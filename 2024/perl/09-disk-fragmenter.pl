
# solution to https://adventofcode.com/2024/day/9

use Test2::V0;
use Path::Class qw(file);
use Function::Parameters;
use Iterator::Simple qw(iterator list);
use MooX::Struct
    Empty => ['length'],
    Data  => ['id', 'length'],
    Block => ['id', 'pos'],
;

my $input_file = "../input/09.txt";
my $data = file($input_file)->slurp(chomp => 1);

my $test = '2333133121414131402';

is disk_image(block_iterator($test)),   '0099811188827773336446555566', 'Correctly defragmented image';
is disk_image(block_iterator('12345')), '022111222',                    'Correctly defragmented image';
is disk_image(block_iterator('90909')), '000000000111111111222222222',  'Correctly defragmented image';

is checksum(block_iterator($test)), 1928,          'Part 1 - test';
is checksum(block_iterator($data)), 6154342787400, 'Part 1 - real';

done_testing;

fun disk_image($iter) {
    my $str = '';
    while(my $item = $iter->next) {
        $str .= $item->id;
    }
    return $str;
}

fun checksum($iter) {
    my $total = 0;
    while(my $item = $iter->next) {
        $total += $item->id * $item->pos;
    }
    return $total;
}

fun _build_blocks($str) {
    my @blocks = ();
    my $i = 0;
    my $id = 0;
    for my $e (split //, $str) {
        push @blocks, $i++ % 2 == 0
            ? Data->new(id => $id++, length => int($e))
            : Empty->new(length => int($e));
    }
    @blocks = grep { $_->length > 0 } @blocks;
    return @blocks;
}

fun block_iterator($str) {
    my @blocks = _build_blocks($str);

    my $pos = 0;
    my $block = 0;
    my $block_start = 0;
    return iterator {

        # debugging
        # warn "[$pos] $block_start, $block: ".join(' ', map { "[". ($_->isa(Data) ? $_->id.":" : "") . $_->length . "]"  } @blocks)."\n";

        my $cur_pos = $pos;
        $pos++;

        return unless defined $blocks[$block];

        # if we are over current block, move to next one
        if($cur_pos >= $block_start + $blocks[$block]->length) {
            $block_start += $blocks[$block]->length;
            $block++;
            return unless defined $blocks[$block];
        }

        # empty block = do the defragmentation
        if($blocks[$block]->isa(Empty)) {
            return if $block == $#blocks;                                               # at the end already?
            pop @blocks while $blocks[-1]->isa(Empty) || $blocks[-1]->length == 0;      # remove empty or len=0 blocks

            # push shortened last block
            my $last_block = pop @blocks;
            push @blocks, Data->new(id => $last_block->id, length => $last_block->length - 1)
                if $last_block->length > 1;

            # defragmented block
            return Block->new(id => $last_block->id, pos => $cur_pos);
        }

        # data block
        return Block->new(id => $blocks[$block]->id, pos => $cur_pos);
    };
}
