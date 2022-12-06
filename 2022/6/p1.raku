my $input = "input".IO.slurp;
my @windows = $input.comb.rotor(4=>-3);
my $o = @windows.pairs.first: {
    .value.unique.elems == .value.elems
};
say $o.key + $o.value.elems;
