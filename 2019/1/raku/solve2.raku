sub MAIN(IO::Path() $input) {
    my @mass = $input.lines.map(*.Int);

    my $fuel_total = 0;
    while @mass.elems > 0 {
        @mass = @mass.map({ ($_ / 3).floor - 2 }).grep({ $_ > 0 });
        $fuel_total += @mass.sum();
    }

    say $fuel_total;
}
