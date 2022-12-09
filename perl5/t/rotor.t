use Test2::V0;
use AoC;

subtest "rotor", sub {
    subtest "chunked(2)", sub {
        my @x = qw(1 2 3 4 5);
        my @y = rotor 2 => 0, @x;
        is \@y, [
            [1,2],
            [3,4],
        ];
    };

    subtest "windowed(3)", sub {
        my @x = (1..5);
        my @y = rotor 3 => -2, @x;
        is \@y, [
            [ 1,2,3 ],
            [ 2,3,4 ],
            [ 3,4,5 ],
        ]
    };
};

subtest "chunked(2)", sub {
    my @x = qw(1 2 3 4 5);
    my @y = chunked 2, @x;
    is \@y, [
        [1,2],
        [3,4],
    ];
};

subtest "windowed(3)", sub {
    my @x = qw(1 2 3 4 5);
    my @y = windowed 3, @x;
    is \@y, [
        [1,2,3],
        [2,3,4],
        [3,4,5],
    ];
};

done_testing;
