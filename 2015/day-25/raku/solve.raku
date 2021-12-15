
sub MAIN(IO::Path() $input) {
    my @wanted = $input.comb(/\d+/);
    my $i = coord-to-index(|@wanted);
    say "\"That's the " ~ $i ~ "-th number.\", says another voice.";
    say "\nSanta quickly calculates... \n\n\t" ~ (20151125 * expmod(252533, $i-1, 33554393)) % 33554393;

    say "\nHo, ho ho...";
}

sub coord-to-index ($wanted-r, $wanted-c) {
    my ($i,$r,$c) = (1,1,1);

    my $inc-r = 1;
    my $inc-c = 2;
    while $r++ < $wanted-r {
        $i += $inc-r;
        $inc-r += 1;
        $inc-c += 1;
    }

    while $c++ < $wanted-c {
        $i += $inc-c;
        $inc-c += 1;
    }

    return $i;
}
