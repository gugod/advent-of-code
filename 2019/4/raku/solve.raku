sub MAIN() {
    # part1();
    part2();
}

sub part2() {
    # my $input = "172851-675869";
    my $count = 0;

    (172851..675869).grep(
        -> $it {
            $it.comb(/1+|2+|3+|4+|5+|6+|7+|8+|9+|0+/).map(*.chars == 2).any &&
            $it.comb.rotor(2 => -1).map({ .[0] <= .[1] }).all
        }).elems.say;
}

sub part1() {
    # my $input = "172851-675869";
    my $count = 0;

    (172851..675869).grep(
        -> $it {
            $it.match(/(.)$0/) &&
            $it.comb.rotor(2 => -1).map({ .[0] <= .[1] }).all
        }).elems.say;*
}
