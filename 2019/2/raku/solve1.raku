
sub MAIN(IO::Path() $input) {
    my @init-state  = $input.slurp.split(",");
    @init-state[1] = "12";
    @init-state[2] = "2";
    my @final-state = play-intcode(@init-state);
    say @final-state[0];
}

sub play-intcode (@code is copy) {
    my $i = 0;
    while @code[$i] ne "99" {
        my ($op1, $op2, $out) = @code[$i+1, $i+2, $i+3];

        given @code[$i] {
            when "1" {
                @code[$out] = (@code[$op1] + @code[$op2]).Str;
                $i += 4;
            }
            when "2" {
                @code[$out] = (@code[$op1] * @code[$op2]).Str;
                $i += 4;
            }
            default {
                die "Unreachable!";
            }
        }
    }

    return @code;
}
