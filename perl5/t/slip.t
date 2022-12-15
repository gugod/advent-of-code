use Test2::V0;
use AoC;

subtest "slip", sub {
    my $x = [1,2,3];
    my $y = [4,5,6];
    my $z = [ slip($x), slip($y) ];
    is $z, [ 1,2,3, 4,5,6 ];
};

subtest "slip takes only 1 argument", sub {
    my $x = [1,2,3];
    my $y = [4,5,6];
    my $z = [ slip $x, $y ];
    is $z, [ 1,2,3,[4,5,6] ];
};

subtest "slip without parenthesis", sub {
    my $x = [1,2,3];
    my $y = [4,5,6];
    my $z = [ slip $x, slip $y ];
    is $z, [ 1,2,3, 4,5,6 ];
};

done_testing;
