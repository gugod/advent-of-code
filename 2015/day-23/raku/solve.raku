sub MAIN(IO::Path() $input) {
    my @program = $input.lines.map({ .split(/<[\ ,]>+/).Array }).Array;

    say "# Part 1";
    go-run-walk(@program, %( :a(0), :b(0) ));

    say "# Part 2";
    go-run-walk(@program, %( :a(1), :b(0) ));
}

sub go-run-walk (@program, %reg) {
    my $i = 0;
    while $i < @program.elems {
        my $i0 = $i;
        my ($instruction, $p1, $p2) = @program[$i];

        given $instruction {
            when "hlf" {
                %reg{$p1} div= 2;
                $i++;
            }
            when "tpl" {
                %reg{$p1} *= 3;
                $i++;
            }
            when "inc" {
                %reg{$p1} += 1;
                $i++;
            }
            when "jmp" {
                $i += $p1;
            }
            when "jie" {
                $i += %reg{$p1} %% 2 ?? $p2 !! 1;
            }
            when "jio" {
                $i += %reg{$p1} == 1 ?? $p2 !! 1;
            }
            default {
                die "Impossible: " ~ [$instruction, $p1, $p2];
            }
        }
        # say [$i0, [$instruction, $p1,  $p2 // |() ], $i, %reg];
    }
    say %reg.raku;
}
