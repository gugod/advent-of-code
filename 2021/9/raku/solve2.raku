
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;

    my $height = @lines.elems;
    my $width  = @lines[0].chars;
    my @terrian = @lines.join.comb>>.Int;

    my sub cur (@p) {
        @p[0] * $width + @p[1]
    }

    my sub neighbours(@p) {
        ((-1, 0), (0, -1), (0, 1), (1, 0))
        .map({ $_ <<+>> (@p[0], @p[1]) })
        .grep({ 0 <= .[0] < $height && 0 <= .[1] < $width })
        .Array;
    }

    my @low-points = gather {
        for (^$height X ^$width) -> ($y, $x) {
            my $p = [$y,$x];
            my $cur = cur($p);
            my @neighbours = neighbours($p).map(&cur);

            my $hcur = @terrian[$cur];
            my @hneighbours = @terrian[ @neighbours ];

            if $hcur < @hneighbours.all {
                take $p;
            }
        }
    }

    my @basin-sizes;
    my @checked;
    for @low-points -> $p {
        my $basin;
        my @s = [ $p ];
        @checked[ cur($p) ] = True;

        while @s.elems > 0 {
            my $p = @s.pop;
            $basin++;

            neighbours($p).map: -> $p {
                my $c = cur($p);
                if !@checked[$c] && @terrian[$c] < 9 {
                    @checked[$c] = True;
                    @s.push($p);
                }
            }
        }

        @basin-sizes.push($basin);
    }

    say [*] @basin-sizes.sort.reverse.[0,1,2];
}
