
sub MAIN ( IO::Path() $input ) {
    my Array @readings = $input.lines.map({ .comb.map(*.Int).Array });
    say oxygen_rating(@readings) * co2_rating(@readings);
}

sub oxygen_rating (@readings) {
    return __compute_rating(@readings, False);
}

sub co2_rating (@readings is copy) {
    return __compute_rating(@readings, True);
}

sub __compute_rating(@readings is copy, Bool $bitflip) {
    my @indices = @readings[0].keys;

    for @indices -> $i {
        last if @readings.elems == 1;
        my $popcount = @readings.map({ .[$i] }).sum();
        my $bit = 2 * $popcount >= @readings.elems ?? 1 !! 0;
        $bit = 1 - $bit if $bitflip;
        @readings = @readings.grep({ .[$i] == $bit });
    }

    return @readings[0].join("").parse-base(2);
}
