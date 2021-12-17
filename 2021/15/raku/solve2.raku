
sub MAIN(IO::Path() $input) {
    my @risk = expand $input.lines.map({ .comb.map({ .Int }) });

    solve-with-spfa(@risk);
    # solve-with-naive(@risk);
    # solve-with-dijkstra(@risk);
}

sub solve-with-spfa (@risk) {
    my $h = @risk.elems;
    my $w = @risk[0].elems;

    my $source = (0,0).join(",");
    my $goal = ($h-1, $w-1).join(",");

    my sub weight ($u, $v) {
        state %memo;
        return %memo{$v} if %memo{$v}:exists;

        my ($y,$x) = $v.split(",");
        return %memo{$v} = @risk[$y][$x];
    }

    my sub neighbours ($v) {
        state %memo;
        return %memo{$v} if %memo{$v}:exists;
        my ($y,$x) = $v.split(",");
        return %memo{$v} //= (
            [$y-1, $x],
            [$y+1, $x],
            [$y, $x-1],
            [$y, $x+1],
        ).grep(
            { (0 <= .[0] < $h) && (0 <= .[1] < $w) }
        ).map(
            { .join(",") }
        ).Array;
    }

    my $dist = spfa( $source, $goal, &neighbours, &weight );
    say $dist;
}

sub spfa ($source, $goal, &neighbours, &weight) {
    my %dist = ( $source => 0 );

    my %Q = ();
    my @Q = [];
    my sub in-queue ($v) { %Q{$v} }
    my sub enqueue  ($v) { @Q.push($v); %Q{$v} = True }
    my sub dequeue  ()   { %Q{ @Q.shift }:delete:k }

    enqueue($source);

    while @Q.elems > 0 {
        my $u = dequeue();
        for neighbours($u).values -> $v {
            my $d = %dist{$u} + weight($u, $v);
            if $d < (%dist{$v} // Inf) {
                %dist{$v} = $d;
                enqueue($v) unless in-queue($v);
            }
        }
    }

    return %dist{$goal};
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
    my @grid2 = [];

    my $h = @grid.elems;
    my $w = @grid[0].elems;

    for ^(5 * $h) -> $y {
        for ^(5 * $w) -> $x {
            @grid2[$y][$x] = (@grid[$y % $h][$x % $w] + ($x div $w) + ($y div $h) - 1) % 9 + 1;
        }
    }

    return @grid2;
}
