sub MAIN(IO::Path() $input) {
    # Examples
    #  R2, L3
    #  R2, R2, R2
    #  R5, L5, R5, R3
    my @instructions = $input.lines.comb(/<[LR]>\d+/);
    my @directions = [[1,0], [0,1], [-1,0], [0,-1], [1,0]]; # north, east, south, west
    my %turn = (:R(1), :L(-1));
    my $facing = 0; # north
    my ($x,$y) = (0,0);
    my %visited;
    for @instructions {
        my (Str() $dir,  Int() $steps) = .match(/(<[LR]>)(\d+)/)[*];
        ($facing += %turn{$dir}) %= 4;
        last if (^$steps).first: {
            ($x,$y) <<+=>> @directions[$facing];
            (++%visited{"$x,$y"}) == 2;
        };
    }
    say ($x,$y).map({ .abs }).sum;
}
