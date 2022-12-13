use Test2::V0;

use AoC;

subtest "parle_2d_map_of_chars", sub {
    my $input = "1234
5678
9012
";
    my @out = parse_2d_map_of_chars($input);
    is 0+@out, 3;
    is 0+@{$out[0]}, 4;
    is \@out, array {
        item array {
            item 1;
            item 2;
            item 3;
            item 4;
        };
        item array {
            item 5;
            item 6;
            item 7;
            item 8;
        };
        item array {
            item 9;
            item 0;
            item 1;
            item 2;
        };
        end()
    };
};

done_testing;
