sub MAIN ($in = "input") {
    my @treescape = $in.IO.lines.map({ .comb.Array }).Array;

    say (^@treescape.elems() X ^@treescape[0].elems()).hyper.grep(
        -> ($r, $c) {
            (
                @treescape[$r][^$c].all(),
                @treescape[$r][$c^..*].all(),
                @treescape[^$r].map({ .[$c] }).all(),
                @treescape[$r^..*].map({ .[$c] }).all(),
            ).any() < @treescape[$r][$c]
        }).elems;
}
