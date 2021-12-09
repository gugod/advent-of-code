
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;

    my $height = @lines.elems;
    my $width  = @lines[0].chars;
    my @terrian = @lines.join.comb>>.Int;

    my sub cur($y, $x) { $y * $width + $x }
    my sub neighbours($y, $x) {
        ((-1, 0), (0, -1), (0, 1), (1, 0))
        .map({ $_ <<+>> ($y, $x) })
        .grep({ 0 <= .[0] < $height && 0 <= .[1] < $width })
    }

    my @low-points;

    for (^$height X ^$width) -> ($y, $x) {
        my $cur = cur($y,$x);
        my @neighbours = neighbours($y, $x).map({ cur(.[0], .[1]) });

        my $hcur = @terrian[$cur];
        my @hneighbours = @terrian[ @neighbours ];

        if $hcur < @hneighbours.all {
            @low-points.push([$y, $x]);
        }
    }

    my @basin-sizes;
    my @checked;
    for @low-points -> [$y,$x] {
        my @basin;

        my @s = [ ($y, $x), ];
        @checked[cur($y,$x)] = True;

        while @s.elems > 0 {
            my ($y, $x) = @s.pop;
            @basin.push([$y,$x]);

            my @neighbours = neighbours($y,$x).grep(
                {
                    my $c = cur(.[0], .[1]);
                    @terrian[$c] < 9 && !@checked[$c]
                }
            );

            if @neighbours.elems > 0 {
                @s.append(@neighbours);
                for @neighbours -> [$y, $x] { @checked[cur($y,$x)] = True };
            }
        }

        @basin-sizes.push: @basin.elems;
    }

    say [*] @basin-sizes.sort.reverse.[0,1,2];
}
