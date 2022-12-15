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
        last if $missingBeaconAt;
        my $x = 0;
        while ($x <= $bound) {
            my $p = [$x, $y];
            if (my $sensor = anySensorNearby($iot, $p)) {
                my $xEnd = xRightEndOfSensorRange($iot, $sensor, $p);
                $x = $xEnd + 1;
            } else {
                $missingBeaconAt = [$x,$y];
                last;
                $x++;
            }
        }
    }

    say 4000000 * $missingBeaconAt->[0] + $missingBeaconAt->[1];
}

main(@ARGV);
exit();

sub countOfSensorOrBeaconAtY ($iot, $y) {
    my $count = 0;
    for ( keys %{$iot->{"sensorAt"}} ) {
        my (undef, $_y) = split(" ", $_);
        $count++ if $y == $_y;
    }
    for ( keys %{$iot->{"beaconAt"}} ) {
        my (undef, $_y) = split(" ", $_);
        $count++ if $y == $_y;
    }
    return $count;
}

sub xRightEndOfSensorRange ($iot, $sensor, $p) {
    my ($sensorAt, $Sd) = @$sensor;
    my ($Sx, $Sy) = @$sensorAt;
    return $Sx + $Sd - abs($Sy - $p->[1]);
}

sub anySensorNearby ($iot, $p) {
    for my $sensor (slip $iot->{"sensors"}) {
        my ($sensorAt, $distance) = @$sensor;
        if (manhattanDistance($p, $sensorAt) <= $distance) {
            return $sensor;
        }
    }
    return undef;
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
