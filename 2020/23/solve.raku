sub MAIN {
    part1;
}

sub part1 {
    my $input = "368195742";
    # my $input = "389125467";

    my $current_pos = 0;
    my @cups = $input.comb>>.Int;
    my $MAX = @cups.max;
    my $MIN = @cups.min;

    say "Init: {@cups.gist}";

    my $round = 0;
    while $round++ < 100 {
        my $current = @cups[0];
        my @picked = @cups[1,2,3];
        my @rest = @cups[4..*];

        my $destination = $current - 1;
        while @rest.map({ $^x == $destination }).none {
            $destination--;
            $destination = $MAX if $destination < $MIN;
        }

        say "Round: $round; Cups: {@cups.gist}; Current: $current; Picked: {@picked.gist}; Destination: $destination";

        my $i = @rest.first($destination, :k);
        @cups = [|@rest[0..$i], |@picked, |@rest[$i^..*], $current];
    }

    say "final: {@cups.gist}";

    my $i = @cups.first(1, :k);
    say (|@cups[$i^..*], |@cups[0..^$i]).join("");

}
