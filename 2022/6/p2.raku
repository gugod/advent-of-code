my $input = "input".IO.slurp;
my @windows = $input.comb.rotor(14=>-13);
my $o = @windows.pairs.first: {
    .value.unique.elems == 14;
};
say $o.key + 14;
