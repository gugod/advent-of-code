use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input") {
    my @nums = mix(map { $_ * 811589153 } slurp($input));
    my $i0 = first { $nums[$_] == 0 } (0..$#nums);
    say sum(
        @nums[ ($i0 + 1000) % @nums ],
        @nums[ ($i0 + 2000) % @nums ],
        @nums[ ($i0 + 3000) % @nums ],
    );
}

main(@ARGV);
exit();

sub mix (@nums) {
    my @indices = 0..$#nums;
    for (1..10) {
        for my $i0 (0..$#nums) {
            my $i = first { $indices[$_] == $i0 } 0..$#indices;
            move(\@indices, $i, $nums[$i0]);
        }
    }
    return @nums[@indices];
}

sub move ( $nums, $i, $steps ) {
    $steps = $steps % (@$nums - 1);
    return if $steps == 0;

    my $inc = $steps > 0 ? 1 : -1;

    my $alt = $steps - ( $inc ) * ( @$nums - 1 );
    if ( abs($alt) < abs($steps) ) {
        $steps = $alt;
        $inc = -1 * $inc;
    }

    for (1 ... abs($steps)) {
        my $j = ($i + $inc) % @$nums;
        ($nums->[$i], $nums->[$j]) = ($nums->[$j], $nums->[$i]);
        $i = $j;
    }
}
