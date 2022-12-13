use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

use JSON::PP qw(decode_json);

sub main ( $input = "input" ) {
    my $in = slurp($input);
    my @packetPairs = map { parsePacket($_) } split(/\n\n?/, $in);

    my @delimitors = ([[2]], [[6]]);
    my @sortedPacketPairs = sort {
        my $o = isOrdered($a, $b);
        defined($o) ? $o ? -1 : 1 : 0
    } (@packetPairs, @delimitors);

    my $p = 1;
    for my $i (0..$#sortedPacketPairs) {
        my $packet = $sortedPacketPairs[$i];
        $p *= ($i+1)
            if refaddr($packet) == refaddr($delimitors[0])
             || refaddr($packet) == refaddr($delimitors[1]);
    }
    say $p;
}
main( @ARGV );
exit();

sub parsePacket ($s) {
    decode_json($s)
}

sub isArray ($o) { ref($o) eq 'ARRAY' }

sub isOrdered ($left, $right) {
    $left = [$left] if !isArray($left);
    $right = [$right] if !isArray($right);

    return undef if @$left == @$right == 0;
    return true if @$left == 0 && 0 < @$right;
    return false if @$left > @$right && @$right == 0;

    if ( !isArray($left->[0]) && !isArray($right->[0]) ) {
        return true if $left->[0] < $right->[0];
        return false if $left->[0] > $right->[0];
    } else {
        my $o = isOrdered( $left->[0], $right->[0] );
        return $o if defined $o;
    }

    return isOrdered( [@{$left}[1..$#$left]], [@{$right}[1..$#$right]] );
}
