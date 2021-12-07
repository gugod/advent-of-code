
sub MAIN(IO::Path() $input) {
    my @pos = $input.comb(/\d+/)>>.Int;

    my $mean = floor( @pos.sum / @pos.elems );

    ($mean <<+<< (-1..1))
    .map(-> $n { $n => @pos.map(-> $p { sum(1..abs($p-$n)) }).sum })
    .min({ .value })
    .say
}
