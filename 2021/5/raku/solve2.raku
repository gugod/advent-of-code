
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines.comb(/\d+/).map(*.Int).batch(4);

    my %space;
    for @lines -> $line {
        # horizontal
        if $line[0] == $line[2] {
            ($line[1], $line[3]).minmax.map({ %space{ "$line[0],$_" }++ });
        }
        # vertical
        if $line[1] == $line[3] {
            ($line[0], $line[2]).minmax.map({ %space{ "$_,$line[1]" }++ });
        }

        # diagonal
        my @slope = [ $line[2] - $line[0], $line[3] - $line[1] ];
        if @slope[0].abs == @slope[1].abs {
            my @step = @slope.map({ $_ / .abs });
            my @p = $line[0,1];
            for 0..@slope[0].abs {
                %space{"@p[0],@p[1]"}++;
                @p = @p «+» @step;
            }
        }
    }
    %space.kv.grep(-> $k, $v { $v > 1 }).elems.say;
}
