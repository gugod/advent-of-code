sub MAIN {
    # part1();
   part2();
}

sub egcd (Int $a, Int $b) {
    if $a == 0 {
        return ($b, 0, 1);
    }
    my ($g, $y, $x) = egcd($b % $a, $a);
    return ($g, $x - ($b div $a) * $y, $y);
}

sub invmod(Int() $a, Int() $m) {
    my ($g, $x, $y) = egcd($a, $m);

    if $g != 1 {
        die "invmod($a,$m) does not exist";
    }

    return $x % $m;
}

sub part2 {
    # my @lines = "input".IO.lines.Array;
    # @lines[1] = "1789,37,47,1889";
    # @lines[1] = "67,7,x,59,61";
    # @lines[1] = "67,7,59,61 ";
    # @lines[1] = "17,x,13,19";

    # my $input = "1789,37,47,1889";

    my $input = "19,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,643,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17,13,x,x,x,x,23,x,x,x,x,x,x,x,509,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,29";

    my @buses;
    for $input.split(",").pairs -> $it {
        if $it.value ne "x" {
            @buses.push({ "id" => $it.value.Int, "offset" => $it.key.Int });
        }
    }

    say @buses;

    my $M = [*] @buses.map({ .<id> });

    my $solution = @buses.map(
        -> $bus {
            my $m = ($M / $bus<id>);
            my $a = (-1 * $bus<offset>) % $bus<id>;

            $a * invmod($m, $bus<id>) * $m;
        }).sum;

    while $solution > $M {
        $solution -= $M;
    }

    say "Part 2: " ~ $solution;
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
