#!/usr/bin/env raku

my @instructions = "input-1".IO.lines.map({ .split(" ") });

my ($hpos, $dpos, $aim) = (0, 0, 0);
for @instructions -> ($what, $offset) {
    given $what {
        when "forward" {
            $hpos += $offset;
            $dpos += $aim * $offset;
        }
        when "up" {
            $aim -= $offset;
        }
        when "down" {
            $aim += $offset;
        }
    }
}

say $hpos * $dpos;
