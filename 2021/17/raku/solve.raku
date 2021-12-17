
sub MAIN(IO::Path() $input) {
    # my $spec = "target area: x=20..30, y=-10..-5";
    my $spec = $input.slurp;
    my @nums = $spec.comb(/\-?\d+/)>>.Int;
    my $xrange = Range.new(|@nums[0, 1]);
    my $yrange = Range.new(|@nums[2, 3]);

    my $solutions = 0;
    my $ymax = -Inf;
    for vx-range($xrange) -> $vx {
        for vy-range($yrange) -> $vy {
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

sub vy-range ($yrange) {
    $yrange.min..$yrange.min.abs;
}

sub vx-range ($xrange) {
    floor(sqrt(2* $xrange.min))..$xrange.max()
}

sub simulate ($xvol is copy, $yvol is copy, $xrange, $yrange) {
    my ($x, $y) = (0, 0);

    my $hit = False;
    my $ymax = 0;
    while $y >= $yrange.min() && $x <= $xrange.max() {
        if  $y <= $yrange.max() && $x >= $xrange.min() {
            $hit = True;
            last;
        }

        $x += $xvol;
        $y += $yvol;
        $xvol -= sign($xvol);
        $yvol -= 1;
        $ymax = max($ymax, $y);
    }

    return ($hit, $ymax);
}
