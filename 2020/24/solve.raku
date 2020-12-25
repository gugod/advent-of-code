
# https://www.redblobgames.com/grids/hexagons/#coordinates-cube
#  nw   ne
#    \ /
# w - o - e
#    / \
#  sw   se
class HexCur {
    has Int $.x = 0;
    has Int $.y = 0;
    has Int $.z = 0;

    method fromStr(::?CLASS:U $class: $xyz) {
        my @c = $xyz.split(",").map({ .Int });
        return $class.new( :x(@c[0]), :y(@c[1]), :z(@c[2]));
    }

    method Str {
        ($!x, $!y, $!z).join(",")
    }

    method neighbours {
        (
            ( 0, -1,  1), # nw
            ( 1, -1,  0), # ne
            ( 1,  0, -1), # e
            ( 0,  1, -1), # se
            (-1,  1,  0), # sw
            (-1,  0,  1), # w
        ).map(
            -> ($x,$y,$z) {
                HexCur.new( :x($x + $!x), :y($y + $!y), :z($z + $!z) );
            }
        );
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

    method move_se {
        $!y -= 1;
        $!z += 1;
    }

    method move_nw {
        $!y += 1;
        $!z -= 1;
    }

}

sub MAIN {
    part2(part1);
}

sub steps ($line) {
    return $line.comb(/(nw | ne | sw | se | w | e)/);
}

sub part2 (%black is copy) {
    say "Day 0: " ~ %black.elems;
    my $day = 0;
    while $day++ < 100 {
        my %neighbours;

        for %black.keys.map({ HexCur.fromStr($^x) }) -> $c {
            for $c.neighbours -> $d {
                %neighbours{$d.Str}++;
            }
        }

        my @coords = %black.keys.Array;
        @coords.append(%neighbours.keys);

        for @coords.unique  -> $c {
            %neighbours{$c} //= 0;
            if %black{$c} {
                if %neighbours{$c} == 0 or %neighbours{$c} > 2 {
                    %black{$c}:delete;
                }
            }
            else {
                if %neighbours{$c} == 2 {
                    %black{$c} = True;
                }
            }
        }

        say "Day $day: " ~ %black.elems;
    }
    say "part 2: " ~ %black.elems;
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

        if %black{$cur.Str} {
            %black{$cur.Str}:delete;
        } else {
            %black{$cur.Str} = True;
        }
    }

    say "part 1: " ~ %black.elems;

    return %black;
}
