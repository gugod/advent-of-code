sub MAIN(IO::Path() $input) {
    my @readings = read-input($input);

    my @byAxis0 = [Z] @readings[0].values;
    my sub oriented($j) {
        my @byAxis = [Z] @readings[$j].values;

        # XXX: tighter bound instead of 3000
        my @orientedByAxis = (0,1,2).map(-> $axis {
            ((0,1,2) X (1,-1) X (-3000..3000)).hyper.map(
                -> ($axis0, $sign, $delta) {
                    my @oriented = @byAxis[$axis].map({ $sign * $^n + $delta }).Array;

                    @oriented if (@oriented (&) @byAxis0[$axis0]).elems >= 12;
                }
            ).first();
        });

        return Nil unless @orientedByAxis.all.so;

        return [Z] @orientedByAxis;
    }

    my @oriented-readings = @readings.keys.map(&oriented);
    .say for @oriented-readings;
}

sub manhatten-distance (@vec) {
    @vec>>.abs.sum
}

sub read-input(IO::Path $input) {
    my @readings = [];
    my $scanner;
    for $input.lines -> $line {
        if $line ~~ /scanner\s+(\d+)/ {
            $scanner = $0.Int;
            @readings[$scanner] = [];
        } elsif my @beacon = $line.comb(/\-?\d+/)>>.Int {
            @readings[$scanner].push(@beacon);
        }
    }
    return @readings;
}

=begin pod

=for References

[Z] transpose 2D arrays: L<https://andrewshitov.com/2019/09/09/how-to-transpose-a-matrix-in-perl-6/>

=end pod
