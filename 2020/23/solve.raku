sub MAIN {
    part1;
    part2;
}

sub cups-join (Int $from, @next-cup, $limit = 15) {
    my $cur = $from;
    my $out = "$cur";
    $cur = @next-cup[$cur];

    my $round = 0;
    until $cur == $from or $round++ >= $limit {
        $out ~= " $cur";
        $cur = @next-cup[$cur];
    }
    return $out;
}

sub play-crap-cups(@cups, $rounds = 100) {
    my $MAX = @cups.max;
    my $MIN = @cups.min;

    my @next-cup = [0];
    @cups.rotor(2 => -1).map(
        -> $it {
            @next-cup[ $it[0] ] = $it[1];
        });
    @next-cup[@cups.tail] = @cups.head;

    my $cur = 3;

    my $round = 0;
    say "Round: $round, cups: { cups-join($cur, @next-cup) }";

    while $round++ < $rounds {
        my @picked = [
            @next-cup[$cur],
            @next-cup[@next-cup[$cur]],
            @next-cup[@next-cup[@next-cup[$cur]]],
        ];

        my $dest = $cur - 1;
        while $dest < $MIN or $dest == any(|@picked, $cur) {
            $dest--;
            if $dest < $MIN {
                $dest = $MAX;
            }
        }

        say "Round: $round, cur: $cur,  dest: $dest, picked: { @picked.gist }, cups: { cups-join($cur, @next-cup) }" if $round %% 10000;

        @next-cup[
            $cur,
            $dest,
            @picked[2],
        ] = [
            @next-cup[@picked[2]],
            @picked[0],
            @next-cup[$dest],
        ];
        $cur = @next-cup[$cur];
    }
    return @next-cup;
}

# example: 389125467
# puzzle: 368195742
sub part2 {
    ## puzzle
    my @cups = (|("368195742".comb.map(*.Int)), |(10..10⁶));

    ## example
    # my @cups = (|("389125467".comb.map(*.Int)), |(10..10⁶));

    my @next = play-crap-cups(@cups, 10 * 10⁶);
    my $c1 = @next[1];
    my $c2 = @next[$c1];
    say "Part 2: " ~ ($c1 * $c2);
}

sub part1 {
    # my $input = "389125467";
    my $input = "368195742";
    my @cups = $input.comb.map(*.Int);
    my @next = play-crap-cups(@cups, 100);

    say "Part 1: " ~ cups-join( 1, @next ).substr(1);
}
