use Test2::V0;
use AoC;

subtest "chars", sub {
    subtest "In list context, chars() returs a list of characters", sub {
        my @o = chars "monkey";
        is \@o, [qw(m o n k e y)];
    };

    subtest "In scalar context, chars() returs the count of characters in given string", sub {
        my $o = chars "monkey";
        is $o, 6;
    };
};

done_testing;
