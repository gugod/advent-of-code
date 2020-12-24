sub MAIN {
    part1;
    # part2;
}

class CupRing {
    has Int $.cup;
    has $.follower is rw;

    method from_array (::?CLASS:U $class: @cups) {
        my $x = $class.new( :cup(@cups[*-1]) );
        my $tail = $x;
        for @cups[ (@cups.end-1)...0 ] -> $cup {
            $x = $class.new( :cup($cup), :follower($x) );
        }
        $tail.follower = $x;
        return $x;
    }

    method find (Int $cup) {
        my $i = 0;

        if self.cup == $cup {
            return self;
        }

        my $found;
        my $cur = self.follower;
        until $cur eqv self {
            if $cur.cup == $cup {
                $found = $cur;
                last;
            }
            $cur = $cur.follower;
        }

        return $found;
    }

    method gist {
        my $head = self.follower;
        my $gist = "" ~ self.cup;
        my $elems = 1;
        until !$head or $head eqv self or $elems++ > 25 {
            $gist ~= " " ~ $head.cup;
            $head = $head.follower;
        }
        my $end = $head.defined ?? ( (not $head eqv self) ?? " ..." !! " :|" ) !! " ||";
        return "[" ~ $gist ~ $end ~ "]";
    }

    method join (Str $delimiter) {
        my $out = "" ~ self.cup;
        my $head = self.follower;
        my $elems = 1;
        until !$head or $head eqv self {
            $out ~= $delimiter ~ $head.cup;
            $head = $head.follower;
        }
        return $out;
    }
}

sub part2 {}

sub part1 {
    # my $input = "368195742";
    my $input = "389125467";

    my @cups = $input.comb>>.Int;

    my $cup-ring = CupRing.from_array(@cups);

    my $MAX = @cups.max;
    my $MIN = @cups.min;

    say "Begin: {$cup-ring.gist} ($MIN ... $MAX )";

    my $current = $cup-ring;
    my $round = 0;
    while $round++ < 100 {
        my $cups_gist = $current.gist;
        my $picked = $current.follower;
        $current.follower = $current.follower.follower.follower.follower;
        $picked.follower.follower.follower = $picked;

        my $picked_gist = $picked.gist;

        my $destination_value = $current.cup - 1;
        while $destination_value < $MIN or $current.cup == $destination_value or $picked.find($destination_value) {
            $destination_value--;
            $destination_value = $MAX if $destination_value < $MIN;
        }
        my $destination = $current.find($destination_value);

        unless $destination {
            die "WHY no destination $destination_value";
        }

        $picked.follower.follower.follower = $destination.follower;
        $destination.follower = $picked;

        say "Round: $round, Current: { $current.cup }, Picked: { $picked_gist }, Destination: { $destination.cup },\n    Cups: { $cups_gist }";

        $current = $current.follower;
    }

    say "Part 1: " ~ $cup-ring.join("");
}
