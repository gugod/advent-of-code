
sub MAIN(IO::Path() $input) {
    my @start-pos = $input.comb(/\d+/)[1,3]>>.Int <<->> 1;
    part1(@start-pos);
}

sub part1(@player-pos) {
    my $player = 0;
    my $dice = 0;
    my @player-score = [0, 0];
    my $rolls = 0;

    say @player-pos ~ "\t" ~ @player-score;
    loop {
        # ($dice % 100 + 1) + (($dice + 1) % 100 + 1) + (($dice + 2) % 100 + 1);
        @player-pos[$player] = (@player-pos[$player] + ((3*$dice + 3) % 100) + 3) % 10;
        @player-score[$player] += @player-pos[$player] + 1;

        $dice = ($dice + 2) % 100 + 1;
        $rolls += 3;

        last if @player-score[$player] >= 1000;

        $player = 1 - $player;
    }

    say @player-score[1 - $player] * $rolls;
}
