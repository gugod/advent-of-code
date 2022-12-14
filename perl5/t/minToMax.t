use Test2::V0;
use AoC;

subtest "minToMax", sub {
    my @x = minToMax(3,9,1);
    is \@x, [1..9];
};

done_testing;
