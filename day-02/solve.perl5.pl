use v5.20;
open my $fh, "<", "input";
my $total = 0;
my $ribon = 0;
while (<$fh>) {
    chomp;
    my ($l,$w,$h) = split "x", $_;
    my @area = ($l*$w, $w*$h, $l*$h);
    my ($min) = sort { $a <=> $b } @area;
    $total += $min + 2 * ( $area[0] + $area[1] + $area[2] );

    my @side = sort { $a <=> $b } ($l,$w,$h);
    $ribon += ($l* $w* $h) + 2*($side[0] + $side[1]);
}
say "Part 1: $total";
say "Part 2: $ribon";

