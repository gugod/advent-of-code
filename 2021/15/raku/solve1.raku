
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;

    my @arena = @lines.map({ .comb>>.Int });
    my @memo = @arena.map({ (0 xx $_.elems).Array }).Array;

    my $rows = @memo.elems;
    my $cols = @memo[0].elems;

    for 1..^$cols -> $x {
        @memo[0][$x] = @memo[0][$x-1] + @arena[0][$x];
    }
    for 1..^$rows -> $y {
        @memo[$y][0] = @memo[$y-1][0] + @arena[$y][0];
        for 1..^$cols -> $x {
            @memo[$y][$x] = min(@memo[$y][$x-1] //0, @memo[$y-1][$x] //0) + @arena[$y][$x];
        }
    }
    say @memo[*-1][*-1];
}
