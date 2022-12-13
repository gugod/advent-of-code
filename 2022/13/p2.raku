sub MAIN($input = "input") {
    my @packets := $input.IO.slurp.split(/\n+/).grep({ .chars > 0 }).map({ parse-packet($_) }).Array;

    my @delimitors = ($[$[2]], $[$[6]]);
    @packets.append(@delimitors);

    my @sorted = @packets.sort(&packet-compare);

    my $decoker-key = [*] @sorted.pairs.grep({ .value === any(@delimitors) }).map({ .key + 1 });
    say $decoker-key;
}

sub parse-packet(Str $s is copy) {
    # (:=])
    use MONKEY-SEE-NO-EVAL;
    $s ~~ s:g/\[/\$\[/;
    EVAL($s)
}

sub packet-compare ( Array() $left, Array() $right ) {
    return 0 if $left.elems == $right.elems == 0;
    return -1 if $left.elems == 0 < $right.elems;
    return 1 if $left.elems > $right.elems == 0;

    my $leftElem = $left[0];
    my $rightElem = $right[0];

    my $o = 0;
    if ($leftElem.isa(Int) && $rightElem.isa(Int)) {
        return -1 if $leftElem < $rightElem;
        return 1 if $leftElem > $rightElem;
        $o = 0;
    } else {
        $o = packet-compare($leftElem, $rightElem);
    }

    return $o if $o != 0;

    return packet-compare( $left[1..$left.end()], $right[1..$right.end()] );

}
