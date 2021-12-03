
sub MAIN ( IO::Path() $input ) {
    my @readings = $input.lines.Array;
    say oxygen_rating(@readings) * co2_rating(@readings);
}

sub oxygen_rating (@readings) {
    return __compute_rating(@readings, False);
}

sub co2_rating (@readings is copy) {
    return __compute_rating(@readings, True);
}

sub __compute_rating(@readings is copy, Bool $bitflip) {
    my %flip = $bitflip
                ?? ( "1" => "0", "0" => "1" )
                !! ( "0" => "0", "1" => "1" );

    for 0..^(@readings[0].chars) -> $i {
        last if @readings.elems == 1;
        my %groups = @readings.classify({ .substr($i, 1) });
        my $bit = %groups{"1"}.elems >= %groups{"0"}.elems ?? %flip{"1"} !! %flip{"0"};
        @readings = %groups{$bit}.Array;
    }
    return @readings[0].join("").parse-base(2);
}
