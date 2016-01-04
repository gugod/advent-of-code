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

multi sub factors($n) {
    state $largest-prime = 13;
    state @known-primes  = (2,3,5,7,11);
    state %memo = @known-primes.map: { $_ => set(1,$_) }
    return %memo{$n} if defined(%memo{$n});

    my $factors;
    for @known-primes -> $p {
        if ($n %% $p) {
            my $m = ($n/$p).Int;
            my $fm = factors($m);
            $factors = set $p, $fm.keys, $fm.keys.map({ $_*$p });
            last;
        }
    }
    $factors //=  set((1, ($largest-prime .. $n/$largest-prime).grep({ $n %% $_ }), $n).flat);
    return %memo{$n} = $factors;
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

sub superscript(Int $n) { "$n".trans(["0","1","2","3","4","5","6","7","8","9"] => ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]) }

sub solve-part-two($input) {
    my $m = -Inf;
    for 4..* -> $house {
        my $f = factors($house);
        my @elves = $f.keys.grep: { $_ * 50 >= $house };
        my $p = 11 * ([+] @elves);

        if ($p > $m) {
            $m = $p;
            my %p = $f.keys.grep({.is-prime}).map({ $f = $_; $f => (1..log($house,$_)).reverse.first({ $house %% ($f**$_) }) });
            say "$house => $p, prime-factors: {%p.keys.sort(&infix:«<=>»).map({ $_ ~ superscript(%p{$_}) })}";
        }
        if $p >= $input {
            say "Part 1: $house";
            last;
        }
    }
}

my ($input) = open("input").lines;
solve-part-two($input);
# solve-part-one($input);