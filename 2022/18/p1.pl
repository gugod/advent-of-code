use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;
use Math::Vector::Real;

sub MAIN ( $input = "input" ) {
    my @cubies = map { V comb(qr/[0-9]+/, $_) } slurp($input);

    my %cubeAt = map { ("@$_" => 1) } @cubies;

    my @sides = map { V(@$_) } ([0,0,1],[0,1,0],[1,0,0],[0,0,-1],[0,-1,0],[-1,0,0]);

    my $count = 0;
    for my $c (@cubies) {
        $count += sum(map { $cubeAt{"@$_"} ? 0 : 1 } map { $c + $_ } @sides);
    }
    say $count;
}
MAIN( @ARGV );
exit();
