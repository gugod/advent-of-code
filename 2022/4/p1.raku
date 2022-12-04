
say elems "input.txt".IO.lines.grep: {
    my @bounds = $_.comb(/<[0..9]>+/);

    (@bounds[0] <= @bounds[2] <= @bounds[3] <= @bounds[1])
    || (@bounds[2] <= @bounds[0] <= @bounds[1] <= @bounds[3])
}
