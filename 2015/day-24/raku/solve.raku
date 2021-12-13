sub MAIN(IO::Path() $input) {
    my @weights = $input.comb(/\d+/)>>.Int;
    say "## Part 1";
    search-optimal-quantum-entanglement(@weights, 3);
    say "## Part 2";
    search-optimal-quantum-entanglement(@weights, 4);
}

sub search-optimal-quantum-entanglement(@weights, $ngroups) {
    my $weight-per-group = @weights.sum / $ngroups;
    (2..@weights.elems).first: -> $size {
        my @groups = @weights.combinations($size).grep({ .sum == $weight-per-group });
        if (@groups.elems > 0) {
            say @groups.map({ [*] $_.values }).min;
            True;
        }
    }
}
