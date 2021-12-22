
sub MAIN(IO::Path() $input) {
    my @instructions = $input.lines.map(
        -> $line {
            my ($cmd) = $line.comb(/^(on|off)/);
            my @nums = $line.comb(/\-?\d+/)>>.Int;
            my @ranges = @nums.batch(2).map({ .[0] .. .[1] });
            [$cmd, |@ranges];
        }
    );

    my $limit_x = -50..50;
    my $limit_y = -50..50;
    my $limit_z = -50..50;

    my %grid;
    for @instructions -> [$cmd, $rx, $ry, $rz] {
        print [$cmd, $rx, $ry, $rz].gist ~ "\t";
        for ($rx (&) $limit_x).keys ->$x {
            for ($ry (&) $limit_y).keys ->$y {
                for ($rz (&) $limit_z).keys ->$z {
                    if $cmd eq "on" {
                        %grid{"$x,$y,$z"} = True;
                    }
                    else {
                        %grid{"$x,$y,$z"}:delete;
                    }
                }
            }
        }
        # print %grid.keys.elems ~ "\n";
    }
    # print "\n";
    say %grid.keys.elems;
}
