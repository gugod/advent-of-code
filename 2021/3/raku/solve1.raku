
sub MAIN ( IO::Path() $input ) {
    my @lines = $input.lines.map({ .comb.map(*.Int) });
    my $line_count = @lines.elems;
    my @pops = [<<+>>] @lines;
    my @gamma_bits   = @pops[0].map({ ($line_count - $_ < $_ ) ?? 1 !! 0 });
    my @epsilon_bits = @gamma_bits.map({ 1 - $_ });
    my Int $gamma = @gamma_bits.join("").parse-base(2);
    my Int $epsilon = @epsilon_bits.join("").parse-base(2);
    say $gamma * $epsilon;
}
