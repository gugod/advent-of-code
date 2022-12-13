sub MAIN($input = "input") {
    my @packets = $input.IO.slurp.split("\n").grep({ .chars > 0 }).map({ parse-packet($_) }).Array;

    my @delimitors = ($[$[2]], $[$[6]]);
    @packets.append(@delimitors);

    my @sorted = @packets.sort(&packet-comparator);

    my $decoker-key = [*] @sorted.pairs.grep({ .value === any(@delimitors) }).map({ .key + 1 });
    say $decoker-key;
}

sub parse-packet-pair (Str $s) {
    %( ("left", "right") Z=> $s.split("\n").map(&parse-packet) );
}

sub parse-packet(Str $s is copy) {
    # (:=])
    use MONKEY-SEE-NO-EVAL;
    $s ~~ s:g/\[/\$\[/;
    EVAL($s)
}

sub packet-comparator($a, $b) {
    my $o = is-correct-order($a, $b);
    return (defined $o) ?? $o ?? -1 !! 1 !! 0;
 }

sub is-correct-order-kv ($it) {
    my ($i, $packet-pair) = $it.kv;
    my $ans = is-correct-order( $packet-pair<left>, $packet-pair<right> );
    return $ans;
}

sub is-correct-order( Array() $left, Array() $right ) {
    return Nil if $left.elems == $right.elems == 0;
    return True if $left.elems == 0 < $right.elems;
    return False if $left.elems > $right.elems == 0;

    my $leftElem = $left[0];
    my $rightElem = $right[0];

    my $o;

    if ($leftElem.isa(Int) && $rightElem.isa(Int)) {
        if $leftElem < $rightElem {
            $o = True
        }
        elsif $leftElem > $rightElem {
            $o = False
        }
        else {
            $o = Nil
        };
    } else {
        $o = is-correct-order($leftElem, $rightElem);
    }

    return $o if defined($o);

    return is-correct-order( $left[1..$left.end()], $right[1..$right.end()] );

}
