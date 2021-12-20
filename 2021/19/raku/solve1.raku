
sub MAIN(IO::Path() $input) {
    my @readings = read-input($input);
    my @scanners = 0..@readings.end;

    my @vec = @readings.values.map: -> $r {
                  $r.keys.combinations(2).map(
                      -> ($i, $j) { "$i $j" => $r[$j] <<->> $r[$i] }
                  ).Hash
              };

    for 0,1 -> $si, $sj {
        @vec[$si]
    }
}

sub manhatten-distance (@vec) {
    @vec>>.abs.sum
}

sub read-input(IO::Path $input) {
    my @readings;
    my $scanner;
    for $input.lines -> $line {
        if $line ~~ /scanner\s+(\d+)/ {
            $scanner = $0.Int;
            @readings[$scanner] = [];
        } elsif my @beacon = $line.comb(/\-?\d+/) {
            @readings[$scanner].push(@beacon);
        }
    }
    return @readings;
}
