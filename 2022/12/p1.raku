sub MAIN ($input = "input") {
    my @height = $input.IO.lines>>.comb;
    my $steps = from-S-to-E(@height);
    say $steps;
}


sub from-S-to-E ( @height ) {
    my $rows = @height.elems();
    my $cols = @height[0].elems();

    my sub find-first($h) {
        (^$rows X ^$cols).first: -> ($y,$x) { @height[$y][$x] eq $h };
    }

    my %memo;
    my sub memo-get ($p) { %memo{"$p"} }
    my sub memo-set ($p, $v) { %memo{"$p"} = $v }

    my sub height-num ($p) {
        given height-of($p) {
            when 'S' { ord('a') }
            when 'E' { ord('z') }
            default  { .ord }
        }
    }

    my sub height-of ($p) {
        @height[ $p[0] ][ $p[1] ];
    }

    my sub neighbours ($p) {
        ([1,0],[-1,0],[0,1],[0,-1]).map({ $_ >>+<< $p }).grep: -> [$y,$x] {
            0 <= $y < $rows && 0 <= $x < $cols
        }
    }

    my $S = find-first 'S';
    my @Q = ($S);
    memo-set($S, 0);

    my $min-steps = Inf;
    while @Q.elems > 0 {
        my $p = @Q.shift;
        if height-of($p) eq 'E' {
            $min-steps = memo-get($p);
            last;
        }

        my $steps = memo-get($p) + 1;
        for neighbours($p) -> $q {
            if (height-num($q) - height-num($p) < 2) && (memo-get($q) // Inf) > $steps {
                memo-set($q, $steps);
                @Q.push($q);
            }
        }
    }

    return $min-steps;
}
