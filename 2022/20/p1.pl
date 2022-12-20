use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub firstIndex :prototype(&@) ($cb, @array) {
    for my $i (0..$#array) {
        local $_ = $array[$i];
        return $i if $cb->($i, $array[$i]);
    }
    return undef;
}

sub main ( $input = "input") {
    my @nums = map { chomp; $_ + 0 } slurp($input);
    @nums = mix(@nums);

    my $indexOfZero = firstIndex { $_ == 0 } @nums;
    say sum(
        rrGet( \@nums, $indexOfZero + 1000 ),
        rrGet( \@nums, $indexOfZero + 2000 ),
        rrGet( \@nums, $indexOfZero + 3000 )
    );
}

main(@ARGV);
exit();

sub rrGet ($rrArray, $index) {
    $rrArray->[ $index % @$rrArray ]
}

sub mix (@nums) {
    my @indices = 0..$#nums;
    for my $i0 (0..$#nums) {
        my $i = firstIndex { $_ == $i0 } @indices;
        move(\@indices, $i, $nums[$i0]);
    }
    return @nums[@indices];
}

sub move ( $nums, $i, $steps ) {
    return if $steps == 0;

    my $inc = $steps > 0 ? 1 : -1;

    for (1 ... abs($steps)) {
        my $j = ($i + $inc) % @$nums;
        ($nums->[$i], $nums->[$j]) = ($nums->[$j], $nums->[$i]);
        $i = $j;
    }
}
