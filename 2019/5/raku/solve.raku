sub MAIN(IO::Path() $input, Int() $user-input = 5) {
    my @code = $input.split(",")>>.Int;
    play-TEST-intcode(@code, $user-input);
}

sub play-TEST-intcode (@code is copy, $user-input) {
    my $i = 0;

    my $halt = False;
    until $halt {
        my $opcode = @code[$i];
        my @modes = (0,0,0);

        if $opcode.chars < 5 {
            $opcode = ("0" x (5 - $opcode.chars)) ~ $opcode;
        }

        @modes = $opcode.substr(0,3).flip.comb;
        $opcode = $opcode.substr(3).Int;

        my sub param($j) {
            # $j in 1..3
            my $c;
            given @modes[$j-1] {
                when "0" { $c = @code[ @code[ $i + $j ] ] }
                when "1" { $c = @code[ $i + $j ] }
                default { die "Impossible mode: @modes[$j]" }
            }
            return $c;
        }

        given $opcode {
            when 1 {
                @code[ @code[$i + 3] ] = param(1) + param(2);
                $i += 4;
            }
            when 2 {
                @code[ @code[$i + 3] ] = param(1) * param(2);
                $i += 4;
            }
            when 3 {
                @code[ @code[$i + 1] ] = $user-input;
                $i += 2;
            }
            when 4 {
                say param(1);
                $i += 2;
            }
            when 5 {
                if param(1) != 0 {
                    $i = param(2);
                } else {
                    $i += 3;
                }
            }
            when 6 {
                if param(1) == 0 {
                    $i = param(2);
                } else {
                    $i += 3;
                }
            }
            when 7 {
                @code[ @code[$i + 3] ] = (param(1) < param(2)) ?? 1 !! 0;
                $i += 4;
            }
            when 8 {
                @code[ @code[$i + 3] ] = (param(1) == param(2)) ?? 1 !! 0;
                $i += 4;
            }
            when 99 {
                $halt = True;
            }
            default {
                die "Unreachable!: @code[$i] opcode=$opcode";
            }
        }
    }

    return;
}
