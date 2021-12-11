#!/usr/bin/env raku

my @instructions = "input-1".IO.lines.map({ .split(" ") });

my ($hpos, $dpos) = (0, 0);
for @instructions -> ($what, $offset) {
    given $what {
        when "forward" {
            $hpos += $offset;
        }
        when "up" {
            $dpos -= $offset;
        }
        when "down" {
            $dpos += $offset;
        }
    }
}

say $hpos * $dpos;
