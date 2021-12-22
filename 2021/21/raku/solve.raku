sub MAIN(IO::Path() $input) {
    my @start-pos = $input.comb(/\d+/)[1,3];
    say "# Part 1";
    part1(@start-pos);

    say "# Part 2";
    part2(@start-pos);
}

sub part2(@pos) {
    # list of: @score, @pos, $player, $universes]
    my @stash;
    @stash.push([[0,0], [0,0], 0, 1]);

    my @wins;
    while @stash.elems != 0 {
        my @universe := @stash.pop;

        my @score    := @universe[0];
        my @pos      := @universe[1];
        my $player    = @universe[2];
        my $universes = @universe[3];

        if @score[0] >= 21 {
            @wins[0] += $universes;
        }
        elsif @score[1] >= 21 {
            @wins[1] += $universes;
        }
        else {
            @stash.append(
                ([3,1], [4,3], [5,6], [6,7], [7,6], [8,3], [9,1]).map(
                    -> ($steps, $frequency) {
                        my @s = @score.clone();
                        my @p = @pos.clone();

                        @p[ $player ] += $steps;
                        @s[ $player ] += (@p[ $player ] = (@p[ $player ] - 1) % 10 + 1);

                        [@s, @p, 1-$player, $universes * $frequency];
                    }
                )
            );
        }
    }
    say @wins.max;
}

sub part2-recursively(@pos) {
    # 1,1,1	=> 3 => 1
    # 1,1,2	=> 4 => 3
    # 1,1,3	=> 5 => 3
    # 1,2,2	=> 5 => 3
    # 1,2,3	=> 6 => 6
    # 1,3,3	=> 7 => 3
    # 2,2,2	=> 6 => 1
    # 2,2,3	=> 7 => 3
    # 2,3,3	=> 8 => 3
    # 3,3,3	=> 9 => 1

    my sub play (@score, @pos, $player) {
        state %memo;
        return %memo{ [|@score,|@pos,$player].join(",") } //= &{
            if @score[0] >= 21 {
                [1, 0];
            } elsif @score[1] >= 21 {
                [0, 1];
            } else {
                my @wins = [0,0];
                for ([3,1], [4,3], [5,6], [6,7], [7,6], [8,3], [9,1]) -> ($steps, $unis) {
                    my @p = @pos;
                    my @s = @score;
                    @p[ $player ] += $steps;
                    @s[ $player ] += (@p[ $player ] = (@p[ $player ] - 1) % 10 + 1);
                    @wins <<+=>> play(@s, @p, 1 - $player).map({ $_ * $unis });
                }
                @wins;
            }
        }();
    }

    my $res = play([0,0], @pos, 0);
    say $res;
    say $res.max();
}

sub part1(@player-pos) {
    my $player = 0;
    my $dice = 0;
    my @player-score = [0, 0];
    my $rolls = 0;

    loop {
        @player-pos[$player] += (((3 * $dice + 3) % 100) + 3) % 10;
        @player-pos[$player] = (@player-pos[$player] - 1) % 10 + 1;
        @player-score[$player] += @player-pos[$player];

        $dice = ($dice + 2) % 100 + 1;
        $rolls += 3;

        last if @player-score[$player] >= 1000;

        $player = 1 - $player;
    }

    say @player-score[1 - $player] * $rolls;
}
