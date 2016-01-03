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

sub presents($house) {
    return sum-of-factors($house) * 10;
}

sub solve-part-one($input) {
    my $m = -Inf;
    for 1..* {
        my $p = presents($_);
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

my ($input) = open("input").lines;
solve-part-one($input);
