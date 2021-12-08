sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    part2(@lines);
    # part1(@lines);
}

sub part2(@lines) {
    my $sum = 0;
    for @lines -> $line {
        my @x = $line.split("|").map(*.words);
        my @in = @x[0].Array;
        my @out = @x[1].Array;

        my @clue = (@in, @out).flat.map({ .comb.sort.join }).unique;

        my %num2clue;
        my %clue2num;
        %clue2num{ @clue.first(*.chars == 2) } = 1;
        %clue2num{ @clue.first(*.chars == 4) } = 4;
        %clue2num{ @clue.first(*.chars == 3) } = 7;
        %clue2num{ @clue.first(*.chars == 7) } = 8;
        %num2clue = %clue2num.pairs.map({ .value => .key.comb.Set });

        for @clue -> $clue {
            next if %clue2num{$clue}:exists;

            my $c = $clue.comb.Set;
            given $clue.chars {
                when 5 {
                    if ($c (>) %num2clue{1}) {
                        %clue2num{$clue} = 3
                    } else {
                        given ($c (&) %num2clue{4}).elems {
                            when 2 {
                                %clue2num{$clue} = 2;
                            }
                            when 3 {
                                %clue2num{$clue} = 5;
                            }
                        }
                    }
                }
                when 6 {
                    if ($c (>) %num2clue{7}) {
                        if ($c (>) %num2clue{4}) {
                            %clue2num{$clue} = 9;
                        } else {
                            %clue2num{$clue} = 0;
                        }
                    } else {
                        %clue2num{$clue} = 6
                    }
                }
            }
        }

        $sum += @out.map({ %clue2num{ .comb.sort.join } // die $_ }).join.Int;
    }

    say $sum;
}

sub part1(@lines) {
    @lines.map({
        .split("|").[1].words.grep({ .chars == 2 | 4 | 3 | 7 }).elems
    }).sum.say
}
