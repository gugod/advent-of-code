sub MAIN ($input = "input") {
    my @height = $input.IO.lines>>.comb;
    my $steps = from-a-to-E(@height);
    say $steps;
}


sub from-a-to-E ( @height ) {
    my $rows = @height.elems();
    my $cols = @height[0].elems();

    my sub neighbours ($p) {
        ([1,0],[-1,0],[0,1],[0,-1]).map({ $_ >>+<< $p }).grep: -> [$y,$x] {
            0 <= $y < $rows && 0 <= $x < $cols
        }
    }

    my sub find-all($h) {
        (^$rows X ^$cols).grep: -> ($y,$x) { @height[$y][$x] eq $h };
    }

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

    my sub min-steps-from ($S) {
        my %memo;

        my @Q = ($S);
        %memo{"$S"} = 0;

        my $min-steps = Inf;
        while @Q.elems > 0 {
            my $p = @Q.shift;
            if height-of($p) eq 'E' {
                $min-steps = %memo{"$p"};
                last;
            }

            my $steps = %memo{"$p"} + 1;
            for neighbours($p) -> $q {
                if (height-num($q) - height-num($p) < 2) && (%memo{"$q"} // Inf) > $steps {
                    %memo{"$q"} = $steps;
                    @Q.push($q);
                }
            }
        }

        return $min-steps;
    }

    (find-all('S').Slip, find-all('a').Slip).hyper.map(&min-steps-from).min();
}
