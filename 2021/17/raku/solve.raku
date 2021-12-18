
sub MAIN(IO::Path() $input) {
    # my $spec = "target area: x=20..30, y=-10..-5";
    my $spec = $input.slurp;
    my ($xrange, $yrange) = $spec.comb(/\-?\d+/)>>.Int.batch(2).map({ Range.new(|$_) });

    my $solutions = 0;
    my $ymax = -Inf;

    for floor(sqrt(2* $xrange.min))..$xrange.max() -> $vx {
        for $yrange.min .. $yrange.min.abs -> $vy {
            my ($hit, $y) = simulate($vx, $vy, $xrange, $yrange);
            if $hit {
                $ymax = max($ymax, $y);
                $solutions++;
            }
        }
    }

    say "# Part 1";
    say $ymax;

    say "# Part 2";
    say $solutions;
}

sub simulate ($vx is copy, $vy is copy, $xrange, $yrange) {
    my ($x, $y) = (0, 0);

    my $hit = False;
    my $ymax = 0;
    while $y >= $yrange.min() && $x <= $xrange.max() {
        if  $y <= $yrange.max() && $x >= $xrange.min() {
            $hit = True;
            last;
        }
        ($x, $y) «+=» ($vx, $vy);
        ($vx, $vy) «+=» (sign($vx), 1);
        $ymax = max($ymax, $y);
    }

    return ($hit, $ymax);
}
