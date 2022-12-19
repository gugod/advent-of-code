use Test2::V0;
use AoC;

subtest "arrayindices", sub {
    my $x = [ 11, 21, 31, 41, 51, 61 ];
    my @indices = arrayindices $x;
    is \@indices, [0,1,2,3,4,5];
};

done_testing;
