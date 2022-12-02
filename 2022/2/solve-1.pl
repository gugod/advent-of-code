use v5.33;

open my $fh, '<', "input.txt";

my %score = (
    X => 1, Y => 2, Z => 3,
    A => 1, B => 2, C => 3,
);

my $scoreTotal = 0;

while (<$fh>) {
    chomp;
    my ($them, $me) = split / /;

    $them = $score{$them};
    $me = $score{$me};

    my $winScore = 0;
    if ($me == $them) {
        $winScore = 3;
    } elsif ($me - $them == 1 || $me - $them == -2) {
        $winScore = 6;
    }

    $scoreTotal += $me + $winScore;
}

say $scoreTotal;
