use v5.33;

open my $fh, '<', "input.txt";

my %score = (
    X => 0, Y => 3, Z => 6,
    A => 1, B => 2, C => 3,
);

my $scoreTotal = 0;

while (<$fh>) {
    chomp;
    my ($them, $me) = split / /;

    my $winScore = $score{$me};
    my $myScore = 0;

    if ($me eq 'Z') {
        $myScore = $score{$them} + 1;
        $myScore = 1 if $myScore == 4;
    }
    elsif ($me eq 'Y') {
        $myScore = $score{$them};
    }
    else {
        $myScore = $score{$them} - 1;
        $myScore = 3 if $myScore == 0;
    }

    $scoreTotal += $myScore + $winScore;
}

say $scoreTotal;
