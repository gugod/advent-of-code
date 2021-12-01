sub MAIN {
    part1;
}

sub trans-num (Int $subject-num, Int $loop-size) {
    constant $nice-prime = 20201227;

    my $v = 1;
    for 1..$loop-size {
        $v *= $subject-num;
        $v %= $nice-prime;
    }

    return $v;
}

sub crack-loop-size (Int $doorkey, Int $subject-num) {
    constant $nice-prime = 20201227;
    my $v = 1;
    my $loop-size = 0;
    until $v == $doorkey {
        $v *= $subject-num;
        $v %= $nice-prime;
        $loop-size++;
    }
    return $loop-size;
}

sub part1 {
    my @pub-keys = "input".IO.lines.map(*.Int);
    my @loop-sizes = @pub-keys.map({ crack-loop-size($^it, 7) });

    say "    keys: {@pub-keys.gist}, loop-sizes: {@loop-sizes.gist}";

    my $enck1 = trans-num(@pub-keys[1], @loop-sizes[0]);
    my $enck2 = trans-num(@pub-keys[0], @loop-sizes[1]);
    say "Part 1: $enck1";
    say "        $enck2";
}
