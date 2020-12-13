sub MAIN {
    # part1();
    part2();
}

sub part2 {
    my @lines = "input".IO.lines.Array;
    # @lines[1] = "1789,37,47,1889";
    # @lines[1] = "67,7,x,59,61";
    # @lines[1] = "67,7,59,61 ";
    # @lines[1] = "17,x,13,19";

    my @buses;
    for @lines[1].split(",").pairs -> $it {
        if $it.value ne "x" {
            @buses.push({ "id" => $it.value.Int, "offset" => $it.key.Int });
        }
    }

    my $leader = @buses.max({ .<id> });
    say "Buses: " ~ @buses.raku;
    say "Leader: " ~ $leader.raku;

    my $t = (1..*).map(
        -> $factor {
            $factor * $leader<id> - $leader<offset>;
        }
    ).race(:batch(1000000), :degree(8)).first(
        -> $t {
            ! @buses.first(-> $bus { ! ( ($t + $bus<offset>) %% $bus<id> ) }).defined
            # @buses.map(-> $bus { ($t + $bus<offset>) %% $bus<id> }).all;
        }
    );

    say "Part 2: $t";
}

sub part1 {
    my @lines = "input".IO.lines.Array;
    my $schedule = @lines[0].Int;
    my @buses = @lines[1].split(",").grep({ $_ ne "x" }).map({ .Int });

    my @bus_schedule = @buses.map(
        -> $id {
            ($id, $id * ($schedule/$id).ceiling)
        });

    my $earliest = @bus_schedule.min(-> ($id, $t) { $t });
    my $wait = $earliest[1] - $schedule;

    say "Part 1: " ~ ($earliest[0] * $wait);
}
