use Test2::V0;
use AoC;

subtest "count", sub {
    subtest "predicate on a list", sub {
        my $n = count { $_ % 2 == 0 } (1..10);
        is $n, 5;
    };

    subtest "predicate on an array", sub {
        my @stuff = (1..10);
        my $n = count { $_ % 2 == 0 } @stuff;
        is $n, 5;
    };
};

done_testing;
