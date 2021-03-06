sub MAIN {
    # part1();
    part2();
}

sub part1 {
    say "Part 1: " ~ gen([1,17,0,10,18,11,6], 2020);
}

sub part2 {
    say "Part 2:" ~ gen([1,17,0,10,18,11,6], 30000000);
}

sub gen (@starting-numbers, Int $turn) {
    say "Starting with: " ~ @starting-numbers.raku;
    my %prev = @starting-numbers.pairs.map({ .value => [ .key, .key ]});

    my $n = @starting-numbers.tail;
    my $i = @starting-numbers.elems;
    for (1..100).map({ $turn / 100 * $_ }) -> $waypoint {
        while $i < $waypoint {
            $n = %prev{$n}[0] - %prev{$n}[1];
            if %prev{$n}:exists {
                %prev{$n}[1] = %prev{$n}[0];
                %prev{$n}[0] = $i;
            } else {
                %prev{$n} = [$i, $i];
            }
            $i++;
        }
        say "{$i} = $n";
    }

    return $n;
}
