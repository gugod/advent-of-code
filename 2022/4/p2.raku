
say elems "input.txt".IO.lines.grep: {
    my ($a,$b,$c,$d) = $_.comb(/<[0..9]>+/);

    ($c ≤ ($a|$b) ≤ $d)
};
