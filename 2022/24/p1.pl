use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input" ) {
    my $world = parseInput($input);

    my $map = $world->{initialMap};

    my $yGoal = elems($map) - 1;
    my $xGoal = elems($map->[0]) - 2;

    my %memo;
    # round y x
    $memo{"0 1"} = 0;
    my @Q = ([0, 1]);

    my $goal = undef;
    my $round = 0;
    while (!defined($goal)) {
        my $prevRound = $round++;
        $map = nextMinute($map);
        say "~~ $round";

        my %Q2;
        for my $p (@Q) {
            my ($y, $x) = @$p;
            for my $q ([$y,$x+1], [$y,$x-1], [$y+1,$x], [$y-1,$x], [$y,$x]) {
                my ($y,$x) = @$q;
                next unless 0 <= $y < @$map && 0 <= $x < @{$map->[0]};
                next unless $map->[$y][$x][0] eq '.';
                $Q2{"$y $x"} //= [$y, $x];
            }
        }
        @Q = values %Q2;

        for my $p (@Q) {
            my ($y,$x) = @$p;
            if ($y == $yGoal && $x == $xGoal) {
                $goal = $round;
                last;
            }

            for my $q ([$y,$x+1], [$y,$x-1], [$y+1,$x], [$y-1,$x], [$y,$x]) {
                my ($_y, $_x) = @$q;
                if (($memo{"$_y $_x"} //-1) == $prevRound) {
                    $memo{"$y $x"} = $round;
                    last;
                }
            }
        }
    }
    die "No ?" unless defined $goal;

    say $goal;
}
main(@ARGV);
exit();

sub visual ($worldMap) {
    my $canvas = "";
    for my $y ( arrayindices $worldMap ) {
        for my $x ( arrayindices $worldMap->[0] ) {
            if (1 == elems $worldMap->[$y][$x]) {
                $canvas .= $worldMap->[$y][$x][0];
            } else {
                $canvas .= elems $worldMap->[$y][$x];
            }
        }
        $canvas .= "\n";
    }
    return $canvas;
}

sub nextMinute ($worldMap0) {
    my $worldMap1 = [];

    my $yEnd = elems( $worldMap0 ) - 1;
    my $xEnd = elems( $worldMap0->[0] ) - 1;

    for my $y ( 0 ... $yEnd ) {
        for my $x ( 0 ... $xEnd ) {
            my $s = [];

            if ( $worldMap0->[$y][$x][0] eq '#' ) {
                push @$s, '#';
            } else {
                my $east = ($x -1 + 1) % ($xEnd - 1) + 1;
                my $west = ($x - 1 - 1) % ($xEnd - 1) + 1;
                my $north = ($y - 1 - 1 ) % ($yEnd - 1) + 1;
                my $south = ($y - 1 + 1) % ($yEnd - 1) + 1;

                push(@$s, '>') if any(@{ $worldMap0->[$y][ $west ] }) eq '>';
                push(@$s, '<') if any(@{ $worldMap0->[$y][ $east ] }) eq '<';
                push(@$s, '^') if any(@{ $worldMap0->[ $south ][$x] }) eq '^';
                push(@$s, 'v') if any(@{ $worldMap0->[ $north ][$x] }) eq 'v';
            }
            push @$s, '.' if @$s == 0;

            $worldMap1->[$y][$x] = $s // ['.'];
        }
    }

    return $worldMap1;
}

sub parseInput ($input) {
    my $world = {
        "blizzards" => [],
        "initialMap" => [],
    };

    my @worldMap = parse_2d_map_of_chars( scalar slurp($input) );
    $world->{"initialMap"} = \@worldMap;

    for my $y ( 0..$#worldMap ) {
        for my $x ( arrayindices $worldMap[0] ) {
            my $o = $worldMap[$y][$x];
            if ($o eq any('>', 'v', '<', '^')) {
                push @{ $world->{"blizzards"} }, [ $worldMap[$y][$x], [$y,$x] ];
            }
            $worldMap[$y][$x] = [ $o ];
        }
    }

    return $world;
}
