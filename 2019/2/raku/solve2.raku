
sub MAIN(IO::Path() $input) {
    my @init-state  = $input.slurp.split(",");
    my ($noun, $verb) = (^100 X ^100).first(
            -> ($n, $v) {
                play-intcode(@init-state, $n, $v) eq "19690720";
            });
    say 100 * $noun + $verb;
}

sub play-intcode (@code is copy, Str() $noun, Str() $verb) {
    @code[1] = $noun;
    @code[2] = $verb;

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

    return @code[0];
}
