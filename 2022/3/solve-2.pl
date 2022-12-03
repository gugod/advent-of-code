use v5.36;
use List::Util qw(first uniq sum);

sub prio ($letter) {
    my $s = ord($letter) - ord('a') + 1;
    return $s if $s > 0;
    return ord($letter) - ord('A') + 27;
}

sub common3 ($seen) {
    first { $seen->{$_} == 3 } keys %$seen;
}

my $total = 0;

my %seen;
my $lineno = 0;
open my $fh, "<", "input.txt";
while (my $sack = <$fh>) {
    chomp($sack);
    $lineno++;

    $seen{$_}++ for uniq split "", $sack;

    if ($lineno == 3) {
        $total += prio(common3(\%seen));
        %seen = ();
        $lineno = 0;
    }
}

die unless $lineno == 0;

say $total;
