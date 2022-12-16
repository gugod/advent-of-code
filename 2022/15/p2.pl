use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

# example 20
sub main ( $input = "input", $bound = 4000000 ) {
    my @sensorData = map { [ chunked 2, comb qr/-?[0-9]+/, $_ ] } slurp($input);

    my $iot = buildIot( \@sensorData );

    my $missingBeaconAt;
    for my $y (0..$bound) {
        my $coverage = computeCoverageAtY($iot, $y);
        @$coverage = map { [ max(0, $_->[0]), min($bound, $_->[1]) ] }
            grep { $_->[0] <= $bound || $_->[1] >= 0 }
            @$coverage;
        # It is specified in the question that there would be only one spot.
        if (@$coverage > 1) {
            $missingBeaconAt = [$coverage->[0][1]+1, $y];
            last;
        }
    }
    say 4000000 * $missingBeaconAt->[0] + $missingBeaconAt->[1];
}

main(@ARGV);
exit();

sub computeCoverageAtY ($iot, $y) {
    my @sensorCoverages = sort { $a->[0] <=> $b->[0] } map {
        my $sensor = $_;
        my ($Sx, $Sy, $r) = (slip $sensor->[0], $sensor->[1]);
        my $dy = abs($Sy - $y);
        my $dx = ($r - $dy);
        ($dx >= 0) ? (
            [ $Sx - $dx, $Sx + $dx ]
        ) : ()
    } ( values %{$iot->{"sensorAt"}} );

    my @yCoverage = ([slip $sensorCoverages[0]]);
    my $i = 0;
    for my $j (1..$#sensorCoverages) {
        if ( $sensorCoverages[$j][0] <= $yCoverage[$i][1] ) {
            $yCoverage[$i][1] = max($yCoverage[$i][1], $sensorCoverages[$j][1]);
        } else {
            push @yCoverage, [ slip $sensorCoverages[$j] ];
            $i++;
        }
    }
    return \@yCoverage;
}

use constant Inf => 2**63;

sub buildIot ( $sensorData ) {
    my %iot = (
        "sensorData" => $sensorData,
        "xMin" => Inf,
        "xMax" => - Inf,
        "sensors" => [],
        "beaconAt" => {},
        "sensorAt" => {},
    );

    for ( @$sensorData ) {
        my ($sensorAt, $beaconAt ) = @$_;
        my $d = manhattanDistance( $sensorAt, $beaconAt );
        my $sensor = [ $sensorAt, $d ];
        push @{$iot{"sensors"}}, $sensor;
        $iot{"sensorAt"}{"@$sensorAt"} = $sensor;
        $iot{"beaconAt"}{"@$beaconAt"} = true;
        $iot{"xMax"} = max $iot{"xMax"}, $sensorAt->[0], $beaconAt->[0], $sensorAt->[0] + $d;
        $iot{"xMin"} = min $iot{"xMin"}, $sensorAt->[0], $beaconAt->[0], $sensorAt->[0] - $d;
    }

    return \%iot;
}

sub manhattanDistance ($a, $b) {
    abs($a->[0] - $b->[0]) + abs($a->[1] - $b->[1])
}
