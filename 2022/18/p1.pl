use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub MAIN ( $input = "input" ) {
    my @cubies = map { ArrayRef comb(qr/[0-9]+/, $_) } slurp($input);

    my %cubeAt;
    for my $c (@cubies) {
        $cubeAt{"@$c"} = 1;
    }

    my @sides = ([0,0,1],[0,1,0],[1,0,0],[0,0,-1],[0,-1,0],[-1,0,0]);

    my $count = 0;
    for my $c (@cubies) {
        $count += sum(map { $cubeAt{"@$_"} ? 0 : 1 } map { vecplus($c,$_) } @sides);
    }
    say $count;
}
MAIN( @ARGV );
exit();

sub vecplus ($x, $y) {
    [ map { $x->[$_] + $y->[$_] } (0 .. $#$x) ]
}
