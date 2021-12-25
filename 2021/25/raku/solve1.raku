
sub MAIN(IO::Path() $input) {
    my @seamap = $input.lines>>.comb>>.Array.Array;
    part1(@seamap);
}

sub part1 (@seamap) {
    my $w := @seamap[0].elems;
    my $h := @seamap.elems;

    # lets-see-sea(@seamap);
    my $steps = 0;
    loop {
        my $moves = 0;
        my @seamap2 = [];

        my @empty = (^$h X ^$w).grep(-> ($y, $x) { @seamap[$y][$x] eq '.'});

        for @empty -> ($y, $x) {
            my $west-of-x = ($x - 1) % $w;
            if @seamap[$y][$west-of-x] eq ">" {
                @seamap2[$y][$x] = ">";
                @seamap2[$y][$west-of-x] = ".";
                $moves++;
            }
        }

        @empty = (^$h X ^$w).grep(-> ($y, $x) { (@seamap2[$y][$x] //= @seamap[$y][$x]) eq '.' });
        for @empty -> ($y, $x)  {
            my $north-of-y = ($y - 1) % $h;
            if @seamap[$north-of-y][$x] eq "v" {
                @seamap2[$y][$x] = "v";
                @seamap2[$north-of-y][$x] = ".";
                $moves++;
            }
        }

        $steps++;
        say "# Step $steps.... $moves sea cucumbers moves";
        # lets-see-sea(@seamap2);

        last if $moves == 0;
        @seamap := @seamap2;
    }

    say "After $steps steps, all sea cucumbers stop moving.";
}

sub lets-see-sea (@seamap) {
    say @seamap>>.join.join("\n"), "\n";

}
