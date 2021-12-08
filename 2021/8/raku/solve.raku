sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    part2(@lines);
    # part1(@lines);
}

sub part2(@lines) {
    @lines.map(
        -> $line {
            my @it = $line.split("|")».words.values;
            my @in = @it[0].values;
            my @out = @it[1].values;

            my @clues = (@in, @out).flat.map({ .comb.sort.join }).unique;

            my %digit = (
                @clues.first(*.chars == 2) => 1,
                @clues.first(*.chars == 4) => 4,
                @clues.first(*.chars == 3) => 7,
                @clues.first(*.chars == 7) => 8,
            );
            my %clue-of-num = %digit.pairs.map({ .value => .key.comb.Set });

            for @clues -> $clue {
                next if %digit{$clue}:exists;

                my $c = $clue.comb.Set;
                given $clue.chars {
                    when 5 {
                        if ($c ⊃ %clue-of-num{1}) {
                            %digit{$clue} = 3
                        } else {
                            given ($c ∩ %clue-of-num{4}).elems {
                                when 2 {
                                    %digit{$clue} = 2;
                                }
                                when 3 {
                                    %digit{$clue} = 5;
                                }
                            }
                        }
                    }
                    when 6 {
                        if ($c ⊃ %clue-of-num{7}) {
                            if ($c ⊃ %clue-of-num{4}) {
                                %digit{$clue} = 9;
                            } else {
                                %digit{$clue} = 0;
                            }
                        } else {
                            %digit{$clue} = 6
                        }
                    }
                }
            }

            @out.map({ %digit{ .comb.sort.join } // die $_ }).join.Int;
        }).sum.say;
}

sub part1(@lines) {
    @lines.map({
        .split("|").[1].words.grep({ .chars == 2 | 4 | 3 | 7 }).elems
    }).sum.say
}
