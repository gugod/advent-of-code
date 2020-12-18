sub MAIN {
    # part1;
    part2;
}

sub part1 {
    say "Part 1: " ~ "input".IO.lines.map(-> $line { evalthis-math($line) }).sum;
}

sub part2 {
    # say evalthis-advmath("6 + (4 * 11) * 42");
    # part2-test();
    say "Part 2: " ~ "input".IO.lines.map(-> $line { evalthis-advmath($line) }).sum;
}

sub part2-test {
    my @cases = (
        231,    "1 + 2 * 3 + 4 * 5 + 6",
        23340,  "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'",
        669060, "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
        1445,   "5 + (8 * 3 + 9 + 3 * 4 * 3)",
        46,     "2 * 3 + (4 * 5)",
        46,     "2 * (4 * 5) + 3 ",
        51,     "1 + (2 * 3) + (4 * (5 + 6))",
        51,     "(2 * 3) + (4 * (5 + 6)) + 1",
        6,      "(2 * 3)",
        50,      "(2 * 3) + 44",
        50,      "44 + (2 * 3)",
        44,      "4 * 5 + 6",
        44,      "(4 * 5 + 6)",
        44,      "4 * (5 + 6)",
        44,      "(4 * (5 + 6))",
        50,      "(6) + (44)",
        50,      "(2 * 3) + (44)",
        50,      "(2 * 3) + (4 * 5 + 6)",
        50,      "(4 * 5 + 6) + (2 * 3)",
        50,      "(2 * 3) + (4 * (5 + 6))",
        50,      "(4 * (5 + 6)) + (2 * 3)",

        2100,   "6 + 44 * 42",
        2100,   "(2 * 3) + 44 * 42",
        2100,   "6 + (4 * 11) * 42",
        2100,   "(2 * 3) + (4 * 11) * 42",
        2100,   "(4 * 11) + (2 * 3) * 42",
        2100,   "(2 * 3) + (4 * (5 + 6)) * 42",
        2100,   "(4 * (5 + 6)) + (2 * 3) * 42",
    );

    for @cases -> $ans, $expr {
        my $y = evalthis-advmath($expr);
        if $y == $ans {
            say "ok - $ans == $expr";
        } else {
            say "not ok - $y != $ans == $expr";
        }
    }
}

sub evalthis-math (Str $expr) {
    # say "----";
    # say $expr;

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

sub evalthis-advmath (Str $expr) {
    # say "# $expr";

    my @tokens = $expr.comb(/<digit>+ | \( | \) | \+ | \*/);

    my @operants;
    my @operators;

    my sub eval-one-op {
        return unless @operants.elems > 1 and @operators.elems > 0;
        my $op = @operators.pop;
        my $b  = @operants.pop;
        my $a  = @operants.pop;
        my $c;

        given $op {
            when "*" {
                $c = $a * $b;
            }
            when "+" {
                $c = $a + $b
            }
            default {
                die "Game over: unknown operator: $op";
            }
        }

        @operants.push($c);
    }

    for @tokens -> $token {
        given ($token) {
            when /<digit>+/ {
                @operants.push($token);
                if @operators.elems > 0 and @operators.tail eq "+" {
                    eval-one-op();
                }
            }
            when "+" {
                if @operators.elems > 0 and @operators.tail eq "+" {
                    eval-one-op();
                }
                @operators.push($token);
            }
            when "*" {
                if @operators.elems > 0 and @operators.tail eq "*"|"+" {
                    eval-one-op();
                }
                @operators.push($token);
            }

            when "(" {
                @operators.push("(");
            }
            when ")" {
                while @operators.tail ne "(" {
                    eval-one-op();
                }
                @operators.pop;
            }
        }

        # say "TOKEN: $token " ~ @operants.gist ~ " " ~ @operators.gist;
    }

    while @operators.elems > 0 {
        eval-one-op();

        # say "TRAILER. " ~ @operants.gist ~ " " ~ @operators.gist;
    }

    return @operants[0];
}
