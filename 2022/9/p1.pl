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

sub tailFollow ($dir) {
    return if abs($T[0] - $H[0]) <= 1 && abs($T[1] - $H[1]) <= 1;
    $T[0] = $H[0] - $V{$dir}[0];
    $T[1] = $H[1] - $V{$dir}[1];
}

for (@lines) {
    my ($dir, $steps) = split " ", $_;
    for (1..$steps) {
        $H[0] += $V{$dir}[0];
        $H[1] += $V{$dir}[1];
        tailFollow($dir);
        $U{"@T"}++;
    }
}
say scalar keys %U;
