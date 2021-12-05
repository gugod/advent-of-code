#!/usr/bin/env raku

sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    my @nums = @lines.first.comb(/\d+/).map(*.Int);
    my @boards = @lines.skip.comb(/\d+/).map(*.Int).rotor(25).map({ .rotor(5) }).Array;
    play-squid-game(@nums, @boards);
}

class BingoBoard {
    # 5x5 2D array
    has $.board;
    has $.marked = [[ False xx 5 ] xx 5 ];
    has Int $.last-marked is rw;
    has Int $.last-marked-i is rw;
    has Int $.last-marked-j is rw;

    method mark ($num) {
        $.last-marked = $num;
        my ($i,$j) = (^5 X ^5).first({ $.board[.[0]][.[1]] == $num });
        if ($i & $j).defined {
            $.marked[$i][$j] = True;
            $.last-marked-i = $i;
            $.last-marked-j = $j;
        }
    }

    method bingo (--> Bool) {
        return (
            ($.last-marked-i.defined && $.marked[$.last-marked-i].all()) ||
            ($.last-marked-j.defined && $.marked[ 0..4; $.last-marked-j].all())
        ).Bool;
    }

    method score (--> Int) {
        return $.last-marked * (
            (^5 X ^5)
            .grep(
                -> ($i, $j) {
                    not $.marked[$i][$j]
                }
            ).map(
                -> ($i, $j) {
                    $.board[$i][$j]
                }
            )
        ).sum();
    }
}

sub play-squid-game (@nums, @boards) {
    my @bingoboards = @boards.map({ BingoBoard.new( :board($_) ) });
    my @last-winners;

    for @nums[0..3] -> $n {
        @bingoboards.map({ .mark($n) });
    }

    for @nums[4..*] -> $n {
        @bingoboards.map({ .mark($n) });
        my %x = @bingoboards.categorize({ .bingo });
        if %x{True} {
            @last-winners = %x{True}.values;
            last unless %x{False};
            @bingoboards = %x{False}.values;
        }
    }

    if @last-winners.elems > 0 {
        @last-winners.map({ .score.say });
    } else {
        die "No winners";
    }
}
