use Test2::V0;
use AoC;

subtest "elems returns the number of elements of one arrayref", sub {
    subtest "in scalar context", sub {
        my $a = [1..10];
        my $c = elems($a);
        is $c, 10;
    };

    subtest "in list context", sub {
        my $a = [1..10];

        my @x = (elems([1..10]), 10);
        is \@x, [10, 10];
    };
};

done_testing;
