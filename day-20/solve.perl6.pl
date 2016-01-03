use v6;

sub prime-factorization($x) {
    my %pf;
    unless ( $x.is-prime ) {
        my $x2 = $x;
        for (2 .. $x/2).grep({ .is-prime && $x %% $_ }) -> $f {
            %pf{$f} = (1..log($x2,$f)).reverse.first({ $x2 %% ($f**$_) });
            $x2 /= ($f ** %pf{$f});
        }
    }
    return %pf;
}

sub presents($house) {
    my $s;
    if ($house.is-prime) {
        $s = 1+$house;
    } else {
        my %pf = prime-factorization($house);
        $s = [*] %pf.pairs.map({ my ($f,$p) = (.key, .value); [+] (0..$p).map({ $f**$_ }) });
    }
    return $s * 10; 
}

sub solve-part-one($input) {
    my $m = -Inf;
    for 1..* {
        my $p = presents($_);
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
solve-part-one($input);
