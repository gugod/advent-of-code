
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;

    my $height = @lines.elems;
    my $width  = @lines[0].chars;
    my @terrian = @lines.join.comb>>.Int;

    my sub cur($y, $x) { $y * $width + $x }

    my $total_risk = 0;
    for (^$height X ^$width) -> ($y, $x) {
        my $cur = cur($y,$x);

        my @neighbours = ((-1, 0), (0, -1), (0, 1), (1, 0))
                             .map({ $_ <<+>> ($y, $x) })
                             .grep({ 0 <= .[0] < $height && 0 <= .[1] < $width })
                             .map({ cur(.[0], .[1]) });

        my $hcur = @terrian[$cur];
        my @hneighbours = @terrian[ @neighbours ];

        if $hcur < @hneighbours.all {
            $total_risk += 1 + $hcur;
        }
    }
    say $total_risk;
}
