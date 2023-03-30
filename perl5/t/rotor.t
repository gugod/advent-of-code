use Test2::V0;
use AoC;

subtest "rotor", sub {
    subtest "chunked(2)", sub {
        my $y = rotor 2 => 0, [qw(1 2 3 4 5)];
        is $y, [
            [1,2],
            [3,4],
        ];
    };

    subtest "windowed(3)", sub {
        my $y = rotor 3 => -2, [1..5];
        is $y, [
            [ 1,2,3 ],
            [ 2,3,4 ],
            [ 3,4,5 ],
        ]
    };
};

subtest "chunked(2)", sub {
    my $y = chunked 2, [ 1, 2, 3, 4, 5 ];
    is $y, [
        [1,2],
        [3,4],
    ];
};

subtest "windowed(3)", sub {
    my $y = windowed 3, [ 1, 2, 3, 4, 5 ];
    is $y, [
        [1,2,3],
        [2,3,4],
        [3,4,5],
    ];
};

done_testing;
