
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines.comb(/\d+/).map(*.Int).batch(4);

    my %space;
    for @lines -> $line {
        my @slope = [ $line[2] - $line[0], $line[3] - $line[1] ];
        if @slope[0].abs == @slope[1].abs != 0 || 0 == @slope.any  {
            my @step = @slope.map({ $_ == 0 ?? 0 !! $_ / $_.abs });
            my $nsteps = @slope.first({ $_ != 0 }).abs;
            my @p = $line[0,1];
            for 0..$nsteps {
                %space{"@p[0],@p[1]"}++;
                @p = @p «+» @step;
            }
        }
    }
    %space.kv.grep(-> $k, $v { $v > 1 }).elems.say;
}
