use v5.36;
use List::Util qw(uniq sum);

my $total = 0;

open my $fh, "<", "input.txt";
while (my $sack = <$fh>) {
    chomp($sack);
    my $len = length($sack) / 2;
    my $comp1 = substr($sack, 0, $len);
    my $comp2 = substr($sack, $len);

    my %seen;
    $seen{$_}++ for uniq split("", $comp1);
    $seen{$_}++ for uniq split("", $comp2);

    my @common = grep { $seen{$_} == 2 } keys %seen;

    my $priority = sum(0, map { ord($_) - ord('a') + 1 } grep { /[a-z]/ } @common)
        + sum (0, map { ord($_) - ord('A') + 27 } grep { /[A-Z]/ } @common);

    $total += $priority;
}
say $total;
