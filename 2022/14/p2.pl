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
        "floor" => 0,
        "deepest" => 0,
        "blockers" => {},
    };
    for my $line (@$input) {
        my @segments = rotor 2, -1, map {[split /,/, $_]} split / -> /, $line;
        for (@segments) {
            my ($begin, $end) = @$_;

            if ($begin->[0] == $end->[0]) {
                my ($b,$e) = minmax( $begin->[1], $end->[1] );
                for ($b..$e) {
                    mark( $terrain, [ $begin->[0], $_ ] );
                }
            } else {
                my ($b,$e) = minmax( $begin->[0], $end->[0] );
                for ($b..$e) {
                    mark( $terrain, [ $_, $begin->[1] ] );
                }
            }
        }
    }
    $terrain->{"floor"} = 2 + $terrain->{"deepest"};
    return $terrain;
}

sub simInfSandDrop ( $S, $terrain = {} ) {
    my $sands = 1;
    while (true) {
        my $restAt = simOneSandDrop( [@$S], $terrain );
        last if same($S, $restAt);
        $sands++;
        mark( $terrain, $restAt, "S" );
    }
    say $sands;
}

sub same ($p1, $p2) {
    $p1->[0] == $p2->[0] && $p1->[1] == $p2->[1];
}

sub simOneSandDrop ($S, $terrain) {
    true while (
        dropDown($S, $terrain) or dropDownLeft($S, $terrain) or dropDownRight($S, $terrain)
    );
    return $S;
}

sub mark ( $terrain, $p, $what = "R" ) {
    $terrain->{"blockers"}{ "@$p" } = $what;
    $terrain->{"deepest"} = $p->[1]
        if $terrain->{"deepest"} < $p->[1];
}

sub isMarked ($terrain, $p) {
    defined($terrain->{"blockers"}{"@$p"}) || $p->[1] >= $terrain->{"floor"};
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
