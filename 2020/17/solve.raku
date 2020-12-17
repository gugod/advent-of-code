
sub MAIN {
    part1;
}

sub part1 {
    my @lines = "input".IO.lines.Array;

    my %energysrc;
    for @lines.kv -> $y, $line {
        for $line.comb.kv -> $x, $v {
            if $v eq '#' {
                %energysrc{"$x,$y,0"} = 1;
            }
        }
    }

    my $cycles = -1;
    while $cycles++ < 6 {
        my @active = %energysrc.keys.map({ .split(",").map({ .Int }) });
        my @activate;
        my @deactivate;

        for @active -> @xyz {
            if active-nabos3d(%energysrc, |@xyz).elems != 2|3 {
                @deactivate.push(@xyz.Array)
            }
        }

        # Only consider cells next to active cells.
        for @active.map(-> @xyz { inactive-nabos3d(%energysrc, |@xyz) }).flat.unique( :with(&[eqv]) ) -> @xyz {
            if active-nabos3d(%energysrc, |@xyz).elems == 3 {
                @activate.push(@xyz.Array);
            }
        }

        for @activate -> @xyz {
            %energysrc{ @xyz.join(",") } = 1;
        }

        for @deactivate -> @xyz {
            %energysrc{ @xyz.join(",") }:delete;
        }

        say "# Cycle $cycles.  active=" ~ @active.elems;
    }
    say "Part 1:           ^^^^^^";
}

sub active-nabos3d(%energysrc, Int $x, Int $y, Int $z) {
    nabo3d($x, $y, $z).grep({ %energysrc{.join(",")}.defined }).Array
}

sub inactive-nabos3d(%energysrc, Int $x, Int $y, Int $z) {
    nabo3d($x, $y, $z).grep({ not %energysrc{.join(",")}.defined }).Array
}

sub nabo3d(Int $x, Int $y, Int $z) {
    ( [$x-1, $x, $x+1] X [$y-1, $y, $y+1] X [$z-1, $z, $z+1]).map(*.Array).grep(-> $xyz { not($xyz eqv [$x,$y,$z]) }).Array;
}
