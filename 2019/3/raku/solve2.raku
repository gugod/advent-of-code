#!/usr/bin/env raku

sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;

    # my @examples = [
    #     ### 30
    #     # "R8,U5,L5,D3",
    #     # "U7,R6,D4,L4",
    #     ### 610
    #     # "R75,D30,R83,U83,L12,D49,R71,U7,L72",
    #     # "U62,R66,U55,R34,D71,R55,D58,R83",
    #     ### 410
    #     # "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
    #     # "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
    # ];

    my @wires = @lines.map({ .split(",") });
    play-wires(@wires);
}

class Point {
    has Int $.x;
    has Int $.y;

    multi method gist(Point:D:) {
        return "⟮" ~ $.x ~ "," ~ $.y ~ "⟯";
    }
}

class Segment {
    has Point $.begin;
    has Point $.end;

    multi method gist(Segment:D:) {
        return $.begin.gist ~ "-" ~ $.end.gist;
    }

    method steps {
        return abs($.begin.x - $.end.x) + abs($.begin.y - $.end.y)
    }

    method steps-to(Point $p) {
        unless self.contains($p) {
            die "Impossible";
        }

        return abs($.begin.x - $p.x) + abs($.begin.y - $p.y)
    }

    method is-horizontal(Segment:D: --> Bool) {
        return $.begin.y == $.end.y
    }

    method is-vertical(Segment:D: --> Bool) {
        return $.begin.x == $.end.x
    }

    method contains(Point $p --> Bool) {
        return (
            # horizontal
            ($.begin.y == $.end.y == $p.y) && (
                ($.begin.x <= $p.x <= $.end.x) || ($.begin.x >= $p.x >= $.end.x)
            )
        ) || (
            # vertical
            ($.begin.x == $.end.x == $p.x) && (
                ($.begin.y <= $p.y <= $.end.y) || ($.begin.y >= $p.y >= $.end.y)
            )
        );
    }
}

class Wire {
    has @.segments;
}

sub play-wires(@wires is copy) {
    @wires = @wires.map({ Wire.new( segments => wire-rel2abs($_) ) });

    my @intersect-points;
    for @wires[0].segments.kv -> $i, $si {
        for @wires[1].segments.kv -> $j, $sj {
            # Skip the pair of the beginning segments -- they overlap at (0,0)
            next if $i == 0 && $j == 0;

            my $p = intersect-point($si, $sj);
            if $p {
                @intersect-points.push($p);
            }
        }
    }

    say @intersect-points.map(
        -> $p {
            my $steps = 0;
            for @wires -> $wire {
                for $wire.segments -> $s {
                    if $s.contains($p) {
                        $steps += $s.steps-to($p);
                        last;
                    } else {
                        $steps += $s.steps;
                    }
                }
            }

            $steps;
        }).min();
}

sub intersect-point (Segment $si, Segment $sj) {
    if $si.is-horizontal {
        if $sj.is-vertical {
            my $p = Point.new( :x($sj.begin.x), :y($si.begin.y) );
            if $si.contains($p) && $sj.contains($p) {
                return $p
            }
        }
    }
    if $si.is-vertical {
        if $sj.is-horizontal {
            my $p = Point.new( :x($si.begin.x), :y($sj.begin.y) );
            if $si.contains($p) && $sj.contains($p) {
                return $p
            }
        }
    }
    return Nil;
}

sub wire-rel2abs (@rel-segments) {
    my $x = 0;
    my $y = 0;

    my @segments = [];
    for @rel-segments -> $s {
        my $dir = $s.substr(0,1);
        my $distance = $s.substr(1).Int;

        my $begin = Point.new( x => $x, y => $y );
        given $dir {
            when "R" { $x += $distance }
            when "L" { $x -= $distance }
            when "D" { $y += $distance }
            when "U" { $y -= $distance }
            default { die "unreachable!" }
        }
        my $end = Point.new( x => $x, y => $y );

        @segments.push( Segment.new( :$begin, :$end ) );
    }
    return @segments;
}

