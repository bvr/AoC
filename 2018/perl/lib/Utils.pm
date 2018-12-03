
package Utils;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(combine);

use Algorithm::Combinatorics qw(combinations);
use Iterator::Simple qw(iterator);

sub combine {
    my ($array, $num) = @_;
    my $it = combinations($array, $num);

    # need to wrap Algorithm::Combinatorics iterator, as it does not work with igrep
    return iterator {
        return $it->next;
    };
}

1;
