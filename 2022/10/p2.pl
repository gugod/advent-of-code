use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

my @lines = slurp(shift // "input", chomp => 1);

my $X = 1;
my $totalCycles = 1;

my $currentInstruction = shift @lines;
my ($cmd, $val) = split " ", $currentInstruction;
my $adding = 0;
my $next = 0;
my @CRT;
while ( $currentInstruction ) {
    my $pixel = ".";
    if (abs((($totalCycles -1) % 40) - $X) < 2) {
        $pixel = "#";
    }
    push @CRT, $pixel;
    if ($totalCycles % 40 == 0) {
        push @CRT, "\n";
    }

    # CPU
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
}

say join "", @CRT;
