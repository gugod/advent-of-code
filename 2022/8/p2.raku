sub MAIN ($in = "input") {
    my @treescape = $in.IO.lines.map({ .comb.Array }).Array;

    my $rows = @treescape.elems();
    my $cols = @treescape[0].elems();
    say (^$rows X ^$cols).hyper.map(
        -> ($r, $c) {
            my $h = @treescape[$r][$c];
            [*] (
                (@treescape[$r][^$c].reverse.first({ $_ >= $h }, :k) // $c - 1),
                (@treescape[$r][$c^..*].first({ $_ >= $h }, :k) // ($cols - $c - 1) - 1),
                (@treescape[^$r].map({ .[$c] }).reverse.first({ $_ >= $h }, :k) // $r - 1),
                (@treescape[$r^..*].map({ .[$c] }).first({ $_ >= $h }, :k) // ($rows - $r - 1) -1),
            ).map({ $_ + 1 });
        }).max;
}
