
sub MAIN(IO::Path() $input) {
    my @risk = expand $input.lines.map({ .comb.map({ .Int }).Array }).Array;
    # solve-with-naive(@risk);

    solve-with-spfa(@risk);
    # solve-with-dijkstra(@risk);
}

sub solve-with-spfa (@risk) {
    my @dist = @risk.map({ (Inf xx $_.elems).Array }).Array;
    @dist[0][0] = 0;

    my $h = @risk.elems;
    my $w = @risk[0].elems;

    my @Q = [];
    @Q.push([0,0]);

    while @Q.elems > 0 {
        my $u = @Q.shift;

        my ($y, $x) = $u.[0,1];
        my @neighbours = ([$y+1,$x], [$y,$x+1], [$y-1,$x], [$y,$x-1]).grep({ 0 <= .[0] < $h && 0 <= .[1] < $w });

        for @neighbours -> $v {
            my $w = @risk[$v[0]][$v[1]];

            my $d = @dist[$u[0]][$u[1]] + $w;
            if $d < @dist[$v[0]][$v[1]] {
                @dist[$v[0]][$v[1]] = $d;

                unless @Q.first({ $_ eqv $v }) {
                    @Q.push($v);
                }
            }
        }
    }

    say @dist[*-1][*-1];
}

sub solve-with-naive(@risk) {
    my @memo = @risk.map({ (Inf xx $_.elems).Array }).Array;
    @memo[0][0] = 0;

    my $rows = @memo.elems;
    my $cols = @memo[0].elems;

    my $updated = True;
    while $updated {
        $updated = False;
        for ^$rows -> $y {
            for ^$cols -> $x {
                next if $y == 0 && $x == 0;

                my @neighbour_risk;

                @neighbour_risk.push( @memo[$y][$x+1] ) if $x < $cols-1;
                @neighbour_risk.push( @memo[$y][$x-1] ) if $x > 0;
                @neighbour_risk.push( @memo[$y+1][$x] ) if $y < $rows-1;
                @neighbour_risk.push( @memo[$y-1][$x] ) if $y > 0;

                if @neighbour_risk.elems > 0 {
                    my $risk = @neighbour_risk.min() + @risk[$y][$x];
                    if $risk != @memo[$y][$x] {
                        @memo[$y][$x] = $risk;
                        $updated = True;
                    }
                }
            }
        }
    }

    say @memo[*-1][*-1];
}

sub solve-with-dijkstra(@risk) {
    my $h = @risk.elems;
    my $w = @risk[0].elems;

    my sub neighbours ($u) {
        state %memo;
        unless %memo{$u}:exists {
            my ($y, $x) = $u.split(",");
            %memo{$u} = ([$y+1,$x], [$y,$x+1], [$y-1,$x], [$y,$x-1])
                            .grep({ 0 <= .[0] < $h && 0 <= .[1] < $w })
                            .map({ .join(",") }).Array;
        }
        return %memo{$u};
    }

    my %risk = (^$h X ^$w).map(-> ($y, $x) { "$y,$x" => @risk[$y][$x] });

    my $goal = ($h-1, $w-1).join(",");
    my %dist = ( "0,0" => 0 );
    my @Q = ["0,0"];
    my %done;

    while @Q.elems > 0 {
        # Take smallest item.
        my ($u) = @Q.splice( @Q.keys.min({ %dist{ @Q[$_] } }), 1 );

        # die "Unexpected: items in Q should not have been marked as done." if %done{$u};

        %done{$u} = True;
        last if $u eq $goal;

        for neighbours($u).values -> $v {
            next if %done{$v};

            my $r = %dist{$u} + %risk{$v};
            if $r < (%dist{$v} // Inf) {
                %dist{$v} = $r;
                @Q.push($v);
            }
        }
    }

    say %dist{ $goal };
}

sub expand(@grid) {
    my @grid2 = @grid;

    my $h = @grid.elems;
    my $w = @grid[0].elems;

    for $h..^(5 * $h) -> $y {
        for ^$w -> $x {
            @grid2[$y][$x] = @grid2[$y - $h][$x] % 9 + 1;
        }
    }

    for ^(5 * $h) -> $y {
        for $w..^(5 * $w) -> $x {
            @grid2[$y][$x] = @grid2[$y][$x - $w] % 9 + 1;
        }
    }

    return @grid2;
}
