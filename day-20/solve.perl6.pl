use v6;

multi sub sum-of-factors($n is copy) {
    my $sum = 1;
    for 2 .. sqrt($n) -> $f {
        my $p = 1;
        while ($n %% $f) {
            $p = $p*$f + 1;
            $n /= $f;
        }
        $sum *= $p;
    }
    $sum *= 1+$n if $n > 1;
    return $sum;
}

sub presents-one($house) {
    return sum-of-factors($house) * 10;
}

multi sub factors(1) { return set(1) }
multi sub factors(2) { return set(1,2) }
multi sub factors(3) { return set(1,3) }

multi sub factors($n) {
    state %memo;
    return %memo{$n} if defined(%memo{$n});

    my $f;
    if ($n %% 2) {
        my $m = ($n/2).Int;
        my $fm = factors($m);
        $f = set 2, $fm.keys, $fm.keys.map({ $_*2 });
    } elsif ($n %% 3) {
        my $m = ($n/3).Int;
        my $fm = factors($m);
        $f = set 3, $fm.keys, $fm.keys.map({ $_*3 });
    } else {
        $f = set((1, (5 .. $n/5).grep({ $n %% $_ }), $n).flat);
    }
    return %memo{$n} = $f;
}

sub presents-two($house) {
    my $f = factors($house);
    my @elves = $f.keys.grep: { $_ * 50 >= $house };
    return 11 * ([+] @elves);
}

sub solve-part-one($input) {
    my $m = -Inf;
    for 1..* {
        my $p = presents-one($_);
        if ($p > $m) {
            say "$_ => $p";
            $m = $p;
        }
        if $p >= $input {
            say "Part 1: $_";
            last;
        }
    }
}

sub solve-part-two($input) {
    my $m = -Inf;
    for 4..* {
        my $p = presents-two($_);
        if ($p > $m) {
            $m = $p;
            say "$_ => $p";
        }
        if $p >= $input {
            say "Part 1: $_";
            last;
        }
    }
}

my ($input) = open("input").lines;
solve-part-two($input);
# solve-part-one($input);

