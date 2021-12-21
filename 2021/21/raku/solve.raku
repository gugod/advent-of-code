
sub MAIN(IO::Path() $input) {
    my @start-pos = $input.comb(/\d+/)[1,3]>>.Int <<->> 1;
    part1(@start-pos);
}

sub part1(@player-pos) {
    my $players = 2;
    my $player = 0;
    my $dice = 0;
    my @player-score = [0, 0];
    my $winner;
    my $rolls = 0;

    say @player-pos ~ "\t" ~ @player-score;
    loop {
        my $steps = 0;
        for ^3 {
            $rolls++;
            $dice = ($dice % 100) + 1;
            $steps += $dice;
        }

        @player-pos[$player] += $steps;
        @player-pos[$player] %= 10;

        @player-score[$player] += @player-pos[$player] + 1;

        # say @player-pos ~ "\t" ~ @player-score;

        if @player-score[$player] >= 1000 {
            $winner = $player;
            last;
        }
        $player = ($player + 1) % 2;
    }

    say @player-score[1 - $player] * $rolls;
}
