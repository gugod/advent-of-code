use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;
use List::MoreUtils qw(minmax);

use JSON::PP qw(decode_json);

sub main ( $input = "input" ) {
    my @input = slurp($input);
    my $terrain = buildTerrain(\@input);
    simInfSandDrop([500,0], $terrain);
}
main(@ARGV);
exit;

sub buildTerrain ( $input ) {
    my $terrain = {
        "deepest" => 0,
        "blockers" => {},
    };
    for my $line (@$input) {
        for (rotor 2 => -1, rotor 2 => 0, comb qr/[0-9]+/, $line) {
            my ($begin, $end) = @$_;
            for my $x (minToMax( $begin->[0], $end->[0] )) {
                for my $y (minToMax( $begin->[1], $end->[1] )) {
                    mark( $terrain, [ $x, $y ] );
                }
            }
        }
    }
    return $terrain;
}

sub simInfSandDrop ( $S, $terrain = {} ) {
    my $sands = 0;
    while (true) {
        my $newSand = [@$S];
        my $restAt = simOneSandDrop( $newSand, $terrain );
        last unless defined $restAt;
        $sands++;
        mark( $terrain, $restAt, "S" );
    }
    say $sands;
}

sub simOneSandDrop ($S, $terrain) {
    my $dropToInf = false;
    true while (
        ! ( $dropToInf = wouldDropToInf($S, $terrain) )
        && (
            dropDown($S, $terrain) or dropDownLeft($S, $terrain) or dropDownRight($S, $terrain)
        )
    );
    return $dropToInf ? undef : $S;
}

sub mark ( $terrain, $p, $what = "R" ) {
    $terrain->{"blockers"}{ "@$p" } = $what;
    $terrain->{"deepest"} = $p->[1]
        if $terrain->{"deepest"} < $p->[1];
}

sub isMarked ($terrain, $p) {
    defined $terrain->{"blockers"}{"@$p"};
}

sub wouldDropToInf ($S, $terrain) {
    $S->[1] >= $terrain->{"deepest"}
}

sub downOf ($S) { [ $S->[0], $S->[1]+1 ] }
sub downLeftOf ($S) { [ $S->[0]-1, $S->[1]+1 ] }
sub downRightOf ($S) { [ $S->[0]+1, $S->[1]+1 ] }
sub isDownBlocked ($S, $terrain) { isMarked($terrain, downOf($S)) }
sub isDownLeftBlocked ($S, $terrain) { isMarked($terrain, downLeftOf($S)) }
sub isDownRightBlocked ($S, $terrain) { isMarked($terrain, downRightOf($S))}

sub dropDown( $S, $terrain ) {
    return undef if isDownBlocked($S, $terrain);
    @$S = @{ downOf($S) };
}

sub dropDownRight( $S, $terrain ) {
    return undef if isDownRightBlocked( $S, $terrain );
    @$S = @{ downRightOf($S) };
}

sub dropDownLeft( $S, $terrain ) {
    return undef if isDownLeftBlocked($S, $terrain);
    @$S = @{ downLeftOf($S) };
}
