
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines.comb(/\d+/).map(*.Int).batch(4);

    # horizontal or vertical
    my %space;
    for @lines -> $line {
        if $line[0] == $line[2] {
            ($line[1], $line[3]).minmax.map({ %space{ "$line[0], $_" }++ });
        }
        if $line[1] == $line[3] {
            ($line[0], $line[2]).minmax.map({ %space{ "$_, $line[1]" }++ });
        }
    }
    %space.kv.grep(-> $k, $v { $v > 1 }).elems.say;
}
