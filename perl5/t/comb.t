use Test2::V0;
use AoC;

subtest "comb", sub {
    my $s = "11,21 -> 31,41 -> 51,61";
    my $nums = comb qr/[0-9]+/, $s;
    is $nums, [ 11, 21, 31, 41, 51, 61 ];
};

done_testing;
