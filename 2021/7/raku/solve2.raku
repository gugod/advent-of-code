
sub MAIN(IO::Path() $input) {
    my @pos = $input.comb(/\d+/)>>.Int;

    @pos
    .minmax
    .map(-> $n { @pos.map(-> $p { sum(1..abs($p-$n)) }).sum })
    .min
    .say
}
