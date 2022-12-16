use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

# example 10
sub main ( $input = "input", $y = 2000000 ) {
    my @sensorData = map { [ chunked 2, comb qr/-?[0-9]+/, $_ ] } slurp($input);

    my $iot = buildIot( \@sensorData );

    my ($xMin, $xMax) = xMinMax($iot);
    my $coverage = computeCoverageAtY($iot, $y);

    # Reduce the coverage ranges to be within sensor+beacon locations
    @$coverage = map { [ max($xMin, $_->[0]), min($xMax, $_->[1]) ] } @$coverage;

    my $count = sum(map { $_->[1] - $_->[0] + 1 } @$coverage)
        - countOfSensorOrBeaconAtY($iot, $y);

    say $count;
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

sub buildIot ( $sensorData ) {
    my %iot = (
        "sensorData" => $sensorData,
        "xMin" => VeryLargeNum,
        "xMax" => - VeryLargeNum,
        "sensors" => [],
        "beaconAt" => {},
        "sensorAt" => {},
    );

    for ( @$sensorData ) {
        my ($sensorAt, $beaconAt ) = @$_;
        my $r = manhattanDistance( $sensorAt, $beaconAt );
        my $sensor = [ $sensorAt, $r ];
        push @{$iot{"sensors"}}, $sensor;
        $iot{"sensorAt"}{"@$sensorAt"} = $sensor;
        $iot{"beaconAt"}{"@$beaconAt"} = true;
        $iot{"xMax"} = max $iot{"xMax"}, $sensorAt->[0], $beaconAt->[0], $sensorAt->[0] + $r;
        $iot{"xMin"} = min $iot{"xMin"}, $sensorAt->[0], $beaconAt->[0], $sensorAt->[0] - $r;
    }

    return \%iot;
}

sub manhattanDistance ($a, $b) {
    abs($a->[0] - $b->[0]) + abs($a->[1] - $b->[1])
}

sub xMinMax ( $iot ) {
    $iot->{"xMin"}, $iot->{"xMax"}
}
