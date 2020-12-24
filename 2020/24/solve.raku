
sub MAIN {
    part1;
}

# https://www.redblobgames.com/grids/hexagons/#coordinates-cube
#  nw   ne
#    \ /
# w - o - e
#    / \
#  sw   se
class HexCur {
    has $!x = 0;
    has $!y = 0;
    has $!z = 0;

    method Str {
        ($!x, $!y, $!z).join(",")
    }

    method move($step) {
        given $step {
            when "e"  { self.move_e }
            when "w"  { self.move_w }
            when "ne" { self.move_ne }
            when "nw" { self.move_nw }
            when "se" { self.move_se }
            when "sw" { self.move_sw }
            default { die "Unknown step: $step" }
        }
    }

    method move_e {
        $!x += 1;
        $!y -= 1;
    }

    method move_w {
        $!x -= 1;
        $!y += 1;
    }

    method move_sw {
        $!x -= 1;
        $!z += 1;
    }

    method move_ne {
        $!x += 1;
        $!z -= 1;
    }

    method move_nw {
        $!y += 1;
        $!z -= 1;
    }

    method move_se {
        $!y -= 1;
        $!z += 1;
    }
}

sub steps ($line) {
    return $line.comb(/(nw | ne | sw | se | w | e)/);
}

sub part1 {
    my %black;

    my @lines = "input".IO.lines;
    for @lines -> $line {
        my @steps = steps($line);
        # say "$line --> " ~ @steps.gist;
        my $cur = HexCur.new;
        for @steps -> $step {
            $cur.move($step);
        }

        if %black{$cur.Str}:exists {
            %black{$cur.Str}:delete;
        } else {
            %black{$cur.Str} = True;
        }
    }

    say "part 1: " ~ %black.elems;
}
