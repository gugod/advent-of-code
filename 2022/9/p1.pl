use v5.36;
use AoC;

my @lines = slurp(shift // "input");
my %U;
my @H = (0,0);
my @T = (0,0);

my %V = (
    "U" => [-1,0], "D" => [1,0],
    "L" => [0,-1], "R" => [0,1],
);

sub tailFollow () {
    my $dr = $H[0] - $T[0];
    my $dc = $H[1] - $T[1];

    return 0 if (abs($dr) <= 1 && abs($dc) <= 1);

    my @moves;
    if ($dr == 0 || $dc == 0) {
        push @moves, "L" if $dc < -1;
        push @moves, "R" if $dc > 1;
        push @moves, "U" if $dr < -1;
        push @moves, "D" if $dr > 1;
    } else {
        push @moves, $dc < 0 ? "L" : "R";
        push @moves, $dr < 0 ? "U" : "D";
    }

    for my $dir (@moves) {
        $T[0] += $V{$dir}[0];
        $T[1] += $V{$dir}[1];
    }

    return 1;
}

for (@lines) {
    my ($dir, $steps) = split " ", $_;
    for (1..$steps) {
        $H[0] += $V{$dir}[0];
        $H[1] += $V{$dir}[1];
        tailFollow();
        $U{"@T"}++;
    }
}
say scalar keys %U;
