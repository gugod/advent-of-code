#!/usr/bin/env raku

sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    my @nums = @lines.shift.split(",").map(*.Int);
    @lines.shift;

    my @boards;
    my @board = [];
    for @lines -> $line {
        if $line eq "" {
            @boards.push: @board.clone();
            @board = [];
        } else {
            my @row = $line.comb(/\d+/).map(*.Int).Array;
            unless @row.elems == 5 {
                die "WUT? [$line] " ~ @row.gist;
            }
            @board.push: @row;
        }
    }
    @boards.push: @board.clone();

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
        for (^5) X (^5) -> ($i, $j) {
            if $.board[$i][$j] == $num {
                $.marked[$i][$j] = True;
                $.last-marked-i = $i;
                $.last-marked-j = $j;
                last;
            }
        }
    }

    method bingo (--> Bool) {
        return (
            ($.last-marked-i.defined && $.marked[$.last-marked-i].all().Bool) ||
            ($.last-marked-j.defined && $.marked[ 0..4; $.last-marked-j].all().Bool)
        );
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
