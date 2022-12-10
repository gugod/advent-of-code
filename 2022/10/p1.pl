use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

my @lines = slurp(shift // "input", chomp => 1);

my $sum = 0;
my $X = 1;
my $totalCycles = 1;
my @waypoints = (20, 60, 100, 140, 180, 220);

my $currentInstruction = shift @lines;
my ($cmd, $val) = split " ", $currentInstruction;
my $adding = 0;
my $next = 0;
while ( $currentInstruction ) {
    if ($cmd eq "addx") {
        if ($adding == 0) {
            $adding = 1;
            $next = 0;
        } else {
            $X += $val;
            $adding = 0;
            $next = 1;
        }
    } else { # noop
        $next = 1;
    }
    $totalCycles++;

    if ($next) {
        $currentInstruction = shift @lines;
        ($cmd, $val) = split " ", $currentInstruction // '';
    }

    if (@waypoints) {
        if ($totalCycles == $waypoints[0]) {
            my $w = shift @waypoints;
            my $s = $w * $X;

            $sum += $s;
            say $w, "\t", $s, "\t", $X, "\t", $sum, "\t", $currentInstruction;
        }
    }
}

say $sum;
