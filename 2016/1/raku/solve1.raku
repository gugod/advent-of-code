sub MAIN(IO::Path() $input) {
    # Examples
    #  R2, L3
    #  R2, R2, R2
    #  R5, L5, R5, R3
    my @instructions = $input.lines.comb(/<[LR]>\d+/, :match);

    my @coord = [0,0];
    my @directions = [[0,1], [-1,0], [0,-1], [1,0]]; # east, south, west, north
    my $facing = 0; # east

    for @instructions {
        my ($dir, $steps) = .match(/(<[LR]>)(\d+)/)[*];
        given $dir {
            when "L" { $facing = ($facing + 1) % 4 }
            when "R" { $facing = ($facing - 1) % 4 }
            default { die "Impossible dir: $dir" }
        }
        @coord <<+=>> @directions[$facing] <<*>> $steps;
    }
    say @coord.map({ .abs }).sum;
}
