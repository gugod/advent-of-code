use v6;

sub pf2n(%p) {
    my $sum = 1;
    for %p.keys -> $f {
        $sum *= $f**%p{$f};
    }
    return $sum;
}

multi sub sum-of-factors(Int $prime, Int $power) {
    state %memo;
    return %memo{$prime}{$power} //= [+] (0..$power).map({ $prime**$_ });
}

multi sub sum-of-factors(%p is copy) {
    my $sum = 1;
    for %p.keys -> $pf {
        $sum *= sum-of-factors($pf.Int, %p{$pf});
    }
    return $sum;
}

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

multi sub nth-prime(0) { 1 }
multi sub nth-prime(1) { 2 }

multi sub nth-prime(Int $n) {
    state @primes;
    return @primes[$n] if @primes[$n];
    my $p = nth-prime($n-1);
    return @primes[$n] = ($p+1..*).first: { .is-prime };
}

sub grid-walk-next(%p, @primes, $max) {
    my $carry = 1;
    for @primes {
        %p{$_} += 1;
        if ( %p{$_} < $max ) {
            $carry = 0;
            last;
        } else {
            %p{$_} = 0;
        }
    }
    if ($carry != 0) {
        return ();
    }
    return %p;
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
    for 786240 -> $house {
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

sub solve-part-two-via-grid-walk($input) {
    my @primes = (1..9).map({ nth-prime($_) });
    my %p = @primes.map: { $_ => 0 };
    %p{2} = 1;
    %p{3} = 1;
    %p{5} = 1;
    %p{7} = 1;

    my $minhouse = Inf;
    my $info;
    while %p {
        my $sof = sum-of-factors(%p);
        my $house = pf2n(%p);
        if ($input < $sof && $house < $minhouse) {
            $minhouse = $house;
            $info = "Part 2: $house $sof {%p.keys.sort(&infix:«<=>»).map({ $_ ~ superscript(%p{$_}) })}";
            say "Progress.. $info";
        }
        %p = grid-walk-next(%p, @primes, 7);
    }
    say $info;
}

my ($input) = open("input").lines;
solve-part-two-via-grid-walk($input);
# solve-part-two($input);
# solve-part-one($input);
