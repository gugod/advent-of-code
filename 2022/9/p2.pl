use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';

use AoC;

my @lines = slurp(shift // "input");
my %U;

my @knot = (
    [0,0],
    [0,0],
    [0,0],
    [0,0],
    [0,0],
    [0,0],
    [0,0],
    [0,0],
    [0,0],
    [0,0],
);

my %V = (
    "U" => [-1,0],
    "D" => [1,0],
    "L" => [0,-1],
    "R" => [0,1],
);

sub knotFollow ($T) {
    my $H = $T - 1;

    my $dr = $knot[$H][0] - $knot[$T][0];
    my $dc = $knot[$H][1] - $knot[$T][1];

    return 0 if (abs($dr) <= 1 && abs($dc) <= 1);

    my @moves;
    if ($dr == 0 || $dc != 0) {
        push @moves, $dc < 0 ? "L" : "R";
    }
    if ($dc == 0 || $dr != 0) {
        push @moves, $dr < 0 ? "U" : "D";
    }

    for my $dir (@moves) {
        $knot[$T][0] += $V{$dir}[0];
        $knot[$T][1] += $V{$dir}[1];
    }

    return 1;
}

$U{ join(" ", @{$knot[9]}) }++;
for my $line (@lines) {
    chomp($line);
    my ($dir, $steps) = split " ", $line;
    for (1..$steps) {
        $knot[0][0] += $V{$dir}[0];
        $knot[0][1] += $V{$dir}[1];
        for (1..9) {
            my $moved = knotFollow($_);
            last unless $moved;
        }
        $U{ join(" ", @{$knot[9]}) }++;
    }
}

say scalar keys %U;
