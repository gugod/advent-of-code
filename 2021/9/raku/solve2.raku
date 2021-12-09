
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;

    my $height = @lines.elems;
    my $width  = @lines[0].chars;
    my @terrian = @lines.join.comb>>.Int;

    my sub cur (@p) {
        @p[0] * $width + @p[1]
    }

    my sub neighbours($y, $x) {
        ((-1, 0), (0, -1), (0, 1), (1, 0))
        .map({ $_ <<+>> ($y, $x) })
        .grep({ 0 <= .[0] < $height && 0 <= .[1] < $width })
        .Array;
    }

    my @low-points = gather {
        for (^$height X ^$width) -> ($y, $x) {
            my $cur = cur [$y,$x];
            my @neighbours = neighbours($y, $x).map(&cur);

            my $hcur = @terrian[$cur];
            my @hneighbours = @terrian[ @neighbours ];

            if $hcur < @hneighbours.all {
                take [$y, $x];
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
            my ($y,$x) = @s.pop;
            $basin++;

            neighbours($y, $x).map: -> $p {
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
