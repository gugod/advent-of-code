use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

use JSON::PP qw(encode_json);

sub heightNum ($h) {
    if ($h eq 'E') {
        return ord('z');
    }
    elsif ($h eq 'S') {
        return ord('a');
    }
    return ord($h);
}

sub neighbours ($heightmap, $currentSpot) {
    my $rowEnd = @$heightmap - 1;
    my $colEnd = @{$heightmap->[0]} - 1;
    my ($y0, $x0) = @$currentSpot;

    return grep {
        my ($y, $x) = @$_;
        (0 <= $y <= $rowEnd) && (0 <= $x <= $colEnd)
    } (
        [$y0, ($x0 + 1)],
        [$y0, ($x0 - 1)],
        [($y0 + 1), $x0],
        [($y0 - 1), $x0],
    );
}

sub visualize ($heightmap, $memo, $prev, $pathEnd ) {
    my $rowEnd = @$heightmap - 1;
    my $colEnd = @{$heightmap->[0]} - 1;

    my @canvas = map {
        [(".") x ($colEnd + 1)]
    } (0..$rowEnd);

    my $spot = $pathEnd;
    my $obj = "E";
    while ($spot) {
        $canvas[$spot->[0]][$spot->[1]] = $obj;

        my $p = $prev->[$spot->[0]][$spot->[1]] or last;

        if ($p->[0] == $spot->[0]) {
            $obj = ($p->[1] < $spot->[1]) ? '>' : '<';
        }
        else {
            $obj = ($p->[0] < $spot->[0]) ? 'v' : '^';
        }
        # $obj = $heightmap->[$p->[0]][$p->[1]];

        $spot = $p;
    }

    say "# VISUALIZE";
    for (@canvas) {
        say (join "", @$_);
    }
    say "";
}

sub findHeight ($heightmap, $height) {
    my $rowEnd = @$heightmap - 1;
    my $colEnd = @{$heightmap->[0]} - 1;
    my @ret;
    for my $y ( 0..$rowEnd ) {
        for my $x ( 0..$colEnd ) {
            if ( $heightmap->[$y][$x] eq $height ) {
                push @ret, [$y, $x];
            }
        }
    }
    return @ret;
}

sub startClimbingFrom ($heightmap, $memo, $startSpot) {
    my $S = $startSpot;
    my @stash = ($S);
    $memo->[$S->[0]][$S->[1]] = 0;

    my @prev;
    my $steps;
    my $spot;
    my $endSpot;
    while (@stash) {
        $spot = shift(@stash);
        my ($y0, $x0) = @$spot;
        my $currentHeightNum = heightNum( $heightmap->[$y0][$x0] );

        if ($heightmap->[$y0][$x0] eq 'E') {
            $endSpot = $spot unless defined($endSpot);
            if ( !defined($steps) || $memo->[$y0][$x0] < $steps ) {
                $steps = $memo->[$y0][$x0];
            }
        }

        for ( neighbours($heightmap, $spot) ) {
            my ($y, $x) = @$_;
            next if 1 < heightNum( $heightmap->[$y][$x] ) - $currentHeightNum;

            my $steps = $memo->[$y0][$x0] + 1;
            if (!defined($memo->[$y][$x]) || $memo->[$y][$x] > $steps) {
                $memo->[$y][$x] = $steps;
                $prev[$y][$x] = [$y0, $x0];
                push @stash, [$y, $x];
            }
        }
    }

    # visualize($heightmap, $memo, \@prev, $endSpot // $spot);

    return $steps;
}

my $in = slurp( shift // "input" );

my @heightmap = map { [split("", $_)] } split("\n", $in);
my @memo;
my @steps;

for my $spot ( findHeight(\@heightmap, 'S'), findHeight(\@heightmap, 'a') ) {
    @memo = ();
    my $s = startClimbingFrom(\@heightmap, \@memo, $spot);
    next unless defined $s;
    push @steps, $s;
}

say min(@steps);
