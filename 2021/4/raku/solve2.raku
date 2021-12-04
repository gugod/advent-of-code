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

    method mark ($num) {
        $.last-marked = $num;
        for (^5) X (^5) -> ($i, $j) {
            if $.board[$i][$j] == $num {
                $.marked[$i][$j] = True;
                last;
            }
        }
    }

    method bingo (--> Bool) {
        for ^5 -> $i {
            if $.marked[$i].all() {
                return True;
            }
        }
        for ^5 -> $i {
            if $.marked[ 0..4; $i].all() {
                return True;
            }
        }
        return False;
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
    my $last-winner;
    for @nums -> $n {
        if @bingoboards.elems == 0 {
            last;
        }

        @bingoboards.map({ .mark($n) });

        my @winners = @bingoboards.grep({ .bingo }, :kv);
        if @winners.elems == 0 {
            say $n ~ "\t" ~ "(no winner)";
        } else {
            for @winners -> $i, $winner {
                @bingoboards[$i] = Nil;

                $last-winner = $winner;
                say $n ~ "\t" ~ $winner.score;
            }
            @bingoboards = @bingoboards.grep({ .defined })
        }
    }

    if $last-winner {
        say $last-winner.score;
    } else {
        die "No winner";
    }
}
