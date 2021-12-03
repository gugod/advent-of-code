
sub MAIN ( IO::Path() $input ) {
    my Array @readings = $input.lines.map({ .comb.map(*.Int).Array });
    say oxygen_rating(@readings) * co2_rating(@readings);
}

sub oxygen_rating (@readings is copy) {
    my @indices = @readings[0].keys;

    for @indices -> $i {
        last if @readings.elems == 1;
        my $half = (@readings.elems / 2);
        my $popcount = @readings.map({ .[$i] }).sum();
        my $bit = $popcount >= $half ?? 1 !! 0;
        @readings = @readings.grep({ .[$i] == $bit });
    }

    return @readings[0].join("").parse-base(2);
}

sub co2_rating (@readings is copy) {
    my @indices = @readings[0].keys;

    for @indices -> $i {
        last if @readings.elems == 1;
        my $half = (@readings.elems / 2);
        my $popcount = @readings.map({ .[$i] }).sum();
        my $bit = $popcount >= $half ?? 0 !! 1;
        @readings = @readings.grep({ .[$i] == $bit });
    }

    return @readings[0].join("").parse-base(2);
}
