my $input = "input".IO.slurp;
my @windows = $input.comb.rotor(4=>-3);
my $o = @windows.pairs.first: {
    .value.unique.elems == 4;
};
say $o.key + 4;
