
sub MAIN(IO::Path() $input) {
    my @instructions = $input.lines.map(
        -> $line {
            my ($cmd) = $line.comb(/^(on|off)/);
            my @nums = $line.comb(/\-?\d+/)>>.Int;
            my @ranges = @nums.batch(2).map({ .[0] .. .[1] });
            [$cmd, |@ranges];
        }
    );
    part1(@instructions);
}

sub part1 (@instructions) {
    my $limit_x = -50..50;
    my $limit_y = -50..50;
    my $limit_z = -50..50;

    my sub cuboids (@xyzranges) { [*] @xyzranges.map({ .values.elems }) }

    my sub overlaps ($i, $j) {
        [*] (1,2,3).map:
            { (@instructions[$i][$_].values (&) @instructions[$j][$_].values).elems }
    }

    my @regions;
    @regions.push({ :switch(@instructions[0][0]), :bound([ @instructions[0][1..3] ]), :memo({}) });

    for @instructions.keys -> $j {
        my ($cmd, $rx, $ry, $rz) = @instructions[$j];
        my $cuboids = cuboids([$rx, $ry, $rz]);
        my %region := {
            :cmd($cmd),
            :cuboids( cuboids[ $rx, $ry, $rz ] ),
            :bound([ $rx, $ry, $rz ]),
            :memo({})
        };

        for (^$j).reverse -> $i {
            my $overlaps = overlaps($i, $j);
            my $cmd_i = @instructions[$i][0];
            my $cmd_j = @instructions[$j][0];

        }
    }
    say $ons;
}
