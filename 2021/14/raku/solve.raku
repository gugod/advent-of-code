
sub MAIN(IO::Path() $input) {
    my @polymer = $input.lines[0].comb;
    my %rules = $input.lines[2..*].flatmap({ .comb(/<[A..Z]>+/) }).pairup;

    my %freq;
    @polymer.rotor(2 => -1).map: {  %freq{ .join() }++ };
    %freq{"_" ~ @polymer[0] } = 1;
    %freq{@polymer[*-1] ~ "_"} = 1;

    # part 1: ^10
    # part 2: ^40
    for ^40 {
        my %freq2;
        for %freq.keys -> $it {
            if %rules{$it} {
                my ($a, $c) = $it.comb;
                my $b = %rules{$it};
                %freq2{"$a$b"} += %freq{$it};
                %freq2{"$b$c"} += %freq{$it};
            } else {
                %freq2{$it} += %freq{$it};
            }
        }
        %freq = %freq2;
    }

    my %cfreq;
    for %freq.keys -> $it {
        for $it.comb -> $c {
            %cfreq{$c} += %freq{$it};
        }
    }
    %cfreq<_>:delete;

    my $mm = %cfreq.values.map({ $_ div 2 }).minmax();
    say $mm.max() - $mm.min();
}
