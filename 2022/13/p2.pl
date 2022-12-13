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
        compare($a, $b);
    } (@packetPairs, @delimitors);

    my @delimitorRefAddr = map { refaddr($_) } @delimitors;

    my $p = product
        grep {
            my $packet = $sortedPacketPairs[$_ - 1];
            any { refaddr($packet) == $_ } @delimitorRefAddr
        }
        (1..@sortedPacketPairs);

    say $p;
}
main( @ARGV );
exit();

sub parsePacket ($s) {
    decode_json($s)
}

sub isArray ($o) { ref($o) eq 'ARRAY' }

# compare: -1: left is smaller, 0: equal, 1: left is larger
sub compare ($left, $right) {
    $left = [$left] if !isArray($left);
    $right = [$right] if !isArray($right);

    return 0 if @$left == @$right == 0;
    return -1 if @$left == 0 && 0 < @$right;
    return 1 if @$left > @$right && @$right == 0;

    if ( !isArray($left->[0]) && !isArray($right->[0]) ) {
        return -1 if $left->[0] < $right->[0];
        return 1 if $left->[0] > $right->[0];
    } else {
        my $o = compare( $left->[0], $right->[0] );
        return $o if $o != 0;
    }

    return compare( [@{$left}[1..$#$left]], [@{$right}[1..$#$right]] );
}
