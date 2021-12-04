#!/usr/bin/env raku

sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
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

sub play-wires(@wires is copy) {
    @wires = @wires.map({ wire-rel2abs($_) });

    my @intersect-points;
    for @wires[0].kv -> $i, $si {
        for @wires[1].kv -> $j, $sj {
            # Skip the very beginning segments -- they overlap at (0,0)
            next if $i == 0 && $j == 0;

            my $p = intersect-point($si, $sj);
            if $p {
                @intersect-points.push($p);
            }
        }
    }

    say @intersect-points.map({ .x.abs + .y.abs }).min();
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

