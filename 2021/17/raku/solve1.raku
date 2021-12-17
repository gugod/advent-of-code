
sub MAIN(IO::Path() $input) {
    # my $spec = "target area: x=20..30, y=-10..-5";
    my $spec = $input.slurp;
    my @nums = $spec.comb(/\-?\d+/)>>.Int;
    my $xrange = Range.new(|@nums[0, 1]);
    my $yrange = Range.new(|@nums[2, 3]);

    my @Vx = vx-range($xrange);
    my @Vy = vy-range($yrange);

    my $solutions = 0;
    my $ymax = -Inf;
    for @Vx -> $vx {
        for @Vy -> $vy {
            my %res = simulate($vx, $vy, $xrange, $yrange);
            if %res<inside> {
                $ymax = max($ymax, %res<ymax>);
                $solutions++;
            }
        }
    }

    say "# Part 1";
    say $ymax;

    say "# Part 2";
    say $solutions;
}

sub vy-range ($yrange) {
    $yrange.min..$yrange.min.abs;
}

sub vx-range ($xrange) {
    floor(sqrt(2* $xrange.min))..$xrange.max()
}

sub sim-y ($vol is copy, $range) {
    my $y = 0;

    my sub step {
        $y += $vol;
        $vol -= 1;
    }

    my sub is-inside { $range.min <= $y <= $range.max }

    my @trace = [$y];
    while $y >= $range.min && !is-inside() {
        step();
        @trace.push($y);
    }

    return ( :inside( is-inside() ), :trace(@trace) );
}

sub sim-x ($xvol is copy, $xrange) {
    my $x = 0;

    my sub step {
        $x += $xvol;
        $xvol -= sign($xvol);
    }

    my sub is-inside { $xrange.min <= $x <= $xrange.max }

    my @trace;
    @trace.push($x);

    while $xvol != 0 && $x <= $xrange.max && ($x <= $xrange.min) {
        step();
        @trace.push($x);
    }

    return ( :inside(is-inside()), :trace(@trace) );
}

sub simulate ($xvol is copy, $yvol is copy, $xrange, $yrange) {
    my ($x, $y) = (0, 0);

    my sub step {
        $x += $xvol;
        $y += $yvol;
        $xvol -= sign($xvol);
        $yvol -= 1;
    }

    sub not-inside {
        ! ($xrange.any == $x && $yrange.any == $y)
    }

    my $ymax = -Inf;
    while not-inside() && !($y < $yrange.min() || $x > $xrange.max()) {
        step();
        $ymax = max($ymax, $y);
    }

    return ( :inside(!not-inside()), :ymax($ymax) );
}
