
use 5.16.3;
use Test::More;
use Path::Class qw(file);
use List::AllUtils qw(sum min);
use Iterator::Simple qw(iter list);

package Dir {
    use Moo;
    use Function::Parameters;
    use List::AllUtils qw(first sum);
    use Iterator::Simple qw(iterator);

    has name    => (is => 'ro');
    has parent  => (is => 'ro');
    has entries => (is => 'ro', default => sub { [] });

    method cd($dir) {
        return $self->parent if $dir eq '..';
        return first { $_->can('entries') && $_->name eq $dir } @{ $self->entries };
    }

    method mkdir($name) {
        push @{ $self->entries }, Dir->new(name => $name, parent => $self);
    }

    method add($file) {
        push @{ $self->entries }, $file;
    }

    method size() {
        return sum map { $_->size } @{ $self->entries };
    }

    method __iter__() {
        my @items = ($self);
        iterator {
            my $curr = shift @items;
            return unless defined $curr;
            push @items, grep { $_->can('entries') } @{ $curr->entries };
            return $curr;
        }
    }
}

package File {
    use Moo;

    has name => (is => 'ro');
    has size => (is => 'ro');
}


my $input_file = "../input/07.txt";
my $lines = iter(file($input_file)->openr);
my $test = iter([
    '$ cd /',
    '$ ls',
    'dir a',
    '14848514 b.txt',
    '8504156 c.dat',
    'dir d',
    '$ cd a',
    '$ ls',
    'dir e',
    '29116 f',
    '2557 g',
    '62596 h.lst',
    '$ cd e',
    '$ ls',
    '584 i',
    '$ cd ..',
    '$ cd ..',
    '$ cd d',
    '$ ls',
    '4060174 j',
    '8033020 d.log',
    '5626152 d.ext',
    '7214296 k',
]);

# part 1
my $test_root = load_fs($test);
is $test_root->size, 48381165, 'test root size';
is sum(grep { $_ < 100_000 } map { $_->size } @{ list(iter($test_root)) }), 95437, "test for directories under 100000B";

my $root = load_fs($lines);
is sum(grep { $_ < 100_000 } map { $_->size } @{ list(iter($root)) }), 1454188, "part 1";

# part 2
my $total_space  = 7_000_0000;
my $needed_space = 3_000_0000;

{   my $need_to_remove = $needed_space - ($total_space - $test_root->size);
    is $need_to_remove, 8381165, 'test - need to remove';
    is min(grep { $_ > $need_to_remove } map { $_->size } @{ list(iter($test_root)) }), 24933642, 'test - remove enough';
}
{   my $need_to_remove = $needed_space - ($total_space - $root->size);
    is $need_to_remove, 3837783, 'part 2 - need to remove';
    is min(grep { $_ > $need_to_remove } map { $_->size } @{ list(iter($root)) }), 4183246, 'part 2 - remove enough';
}

done_testing;

sub load_fs {
    my ($lines) = @_;

    my $root = Dir->new;
    my $curr = $root;
    my $line;
    CMD: while(defined($line = $lines->next)) {
        chomp($line);
        next unless $line =~ /^\$ \s (\w+) (?:\s+ ([^\s]+))?$/x;
        my ($cmd, $arg) = ($1, $2);

        if($cmd eq 'cd' && $arg eq '/') {
            $curr = $root;
        }
        elsif($cmd eq 'cd') {
            $curr = $curr->cd($arg);
        }
        elsif($cmd eq 'ls') {
            while(defined($line = $lines->next)) {
                redo CMD if $line =~ /^\$/;

                if($line =~ /dir \s+ ([^\s]+)$/x) {
                    $curr->mkdir($1);
                }
                elsif($line =~ /(\d+) \s+ ([^\s]+)/x) {
                    $curr->add(File->new(name => $2, size => $1));
                }
            }
        }
    }
    return $root;
}
