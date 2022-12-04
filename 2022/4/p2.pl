use v5.36;
use List::Util qw(min max);
open my $fh, "<", "input.txt";
say 0+ grep {
    my ($a,$b,$c,$d) = $_ =~ m/([0-9]+)/g;
    max($a, $c) <= min($b, $d)
} <$fh>;
