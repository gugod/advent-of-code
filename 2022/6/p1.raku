my $input = "input".IO.slurp;
my $o = $input.comb.rotor(4 => -3).pairs.first: {
    .value.unique.elems == .value.elems
};
say $o.key + $o.value.elems;
