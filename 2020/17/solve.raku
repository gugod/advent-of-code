
sub MAIN {
    part1;
    part2;
}

sub conway (%energysrc, Code $nabos) {
    my @active = %energysrc.keys;

    my $cycles = 0;
    while $cycles++ < 6 {
        my @deactivate = @active.race.grep(-> $where { active-nabos(%energysrc, $where, $nabos).elems != 2|3 });
        # Only consider cells next to active cells.
        my @activate = @active.race.map(-> $where { inactive-nabos(%energysrc, $where, $nabos) }).flat.unique( :with(&[eqv]) ).grep(-> $where { active-nabos(%energysrc, $where, $nabos) == 3 });

        for @activate -> $where {
            %energysrc{$where} = 1;
        }

        for @deactivate -> $where {
            %energysrc{$where}:delete;
        }

        @active = %energysrc.keys;
        say "# Cycle $cycles.  active=" ~ @active.elems;
    }
    return @active.elems;
}

sub part1 {
    my @lines = "input".IO.lines.Array;

    my %energysrc;
    for @lines.kv -> $y, $line {
        for $line.comb.kv -> $x, $v {
            if $v eq '#' {
                %energysrc{"$x,$y,0"} = 1;
            }
        }
    }

    say "Part 1: " ~ conway(%energysrc, &nabos3d);
}

sub part2 {
    my @lines = "input".IO.lines.Array;

    my %energysrc;
    for @lines.kv -> $y, $line {
        for $line.comb.kv -> $x, $v {
            if $v eq '#' {
                %energysrc{"$x,$y,0,0"} = 1;
            }
        }
    }

    say "Part 1: " ~ conway(%energysrc, &nabos4d);
}

sub active-nabos(%energysrc, $where, Code $nabos) {
    $nabos($where).grep(-> $w { %energysrc{$w}.defined }).Array
}

sub inactive-nabos(%energysrc, $where, Code $nabos) {
    $nabos($where).grep(-> $w { not %energysrc{$w}.defined }).Array
}

use experimental :cached;

sub nabos3d(Str $where) is cached {
    my ($x,$y,$z) = $where.split(",").map({ .Int });
    ( [$x-1, $x, $x+1] X [$y-1, $y, $y+1] X [$z-1, $z, $z+1]).map(*.Array).grep(-> $xyz { not($xyz eqv [$x,$y,$z]) }).map({ .join(",") }).Array;
}

sub nabos4d(Str $where) is cached {
    my ($x,$y,$z,$w) = $where.split(",").map({ .Int });
    ( [$x-1, $x, $x+1] X [$y-1, $y, $y+1] X [$z-1, $z, $z+1] X [$w-1, $w, $w+1]).map(*.Array).grep(-> $xyzw { not($xyzw eqv [$x,$y,$z,$w]) }).map({ .join(",") }).Array;
}

