
package Utils;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(combine accumulate);

use Algorithm::Combinatorics qw(combinations);
use Iterator::Simple qw(iterator iter);

sub combine {
    my ($array, $num) = @_;
    my $it = combinations($array, $num);

    # need to wrap Algorithm::Combinatorics iterator, as it does not work with igrep
    return iterator {
        return $it->next;
    };
}

sub accumulate(&$) {
    my ($f, $iter) = @_;
    $iter = iter($iter);        # wrap

    my $pkg = caller;
    my $total = 0;

    no strict 'refs';
    my $glob_b = \*{"${pkg}::b"};


    my $total = 0;
    return iterator {
        my $el = $iter->next;
        return unless defined $el;
        local *{"${pkg}::a"} = \$total;
        local *$glob_b = \$el;
        return $total = $f->();
    }
}

1;
