sub MAIN($input = "input") {
    my @packet-pairs = $input.IO.slurp.split("\n\n").map({ parse-packet-pair($_) }).Array;
    my $answer = @packet-pairs.pairs.grep(&is-correct-order-kv).map({ .key + 1 });
    say $answer.sum;
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

    my $o = Nil;
    if ($leftElem.isa(Int) && $rightElem.isa(Int)) {
        return True if $leftElem < $rightElem;
        return False if $leftElem > $rightElem;
    } else {
        $o = is-correct-order($leftElem, $rightElem);
    }

    return $o if defined($o);

    return is-correct-order( $left[1..$left.end()], $right[1..$right.end()] );

}
