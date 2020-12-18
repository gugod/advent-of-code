sub MAIN {
    # say evalthis("42");
    # say evalthis("1 +42");
    # say evalthis("1 + 2 + 3");
    # say evalthis("1 + 8 * 3");
    # say evalthis("(1 + 8 * 5) * 3");
    part1;
}

sub part1 {
    say "Part 1: " ~ "input".IO.lines.map(-> $line { evalthis($line) }).sum;
}

sub evalthis (Str $expr) {
    say "----";
    say $expr;

    my @tokens = $expr.comb(/<digit>+ | \( | \) | \+ | \*/);

    my @ops;

    my sub maybe-eval-top {
        return unless @ops.elems > 2;
        my ($op, $a, $b) = @ops.tail(3);

        unless ( (($a & $b) ~~ Int) and ($op eq ('+'|'*'))) {
            return;
        }

        @ops.pop;
        @ops.pop;
        @ops.pop;

        my $c;
        if $op eq '+' {
            $c = $a + $b;
        }
        elsif $op eq '*' {
            $c = $a * $b;
        }
        else {
            die "Game over";
        }
        @ops.push($c);
    }

    for @tokens -> $token {
        given ($token) {
            when /<digit>+/ {
                @ops.push( $token.Int );
            }
            when "+" | "*" {
                my $x = @ops.pop;
                @ops.push($token);
                @ops.push($x);
            }
            when "(" {
                @ops.push("(");
            }
            when ")" {
                my $x = @ops.pop;
                @ops.pop;
                @ops.push($x);
            }
        }
        maybe-eval-top;
        # say @ops;
    }

    maybe-eval-top;
    if @ops.elems > 1 {
        die "Game over";
    }
    say "    = @ops[0]";

    return @ops[0];
}
