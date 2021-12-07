
sub MAIN(IO::Path() $input) {
    my @pos = $input.comb(/\d+/)>>.Int.sort;

    ( @pos >>->> median(@pos) ).>>.abs .sum .say
}

sub median (@nums) {
    my $i = floor(@nums.elems / 2);
    return @nums.elems %% 2 ?? @nums[ $i, $i+1 ].sum / 2 !! @nums[$i];
}
