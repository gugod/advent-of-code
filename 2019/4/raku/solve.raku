sub MAIN() {
    say "# Part 2";
    part2();
    say "# Part 1";
    part1();
}

sub part2() {
    # my $input = "172851-675869";
    my $count = 0;
    my $p = next_password(172851);
    while $p < 675869 {
        if $p.comb(/1+|2+|3+|4+|5+|6+|7+|8+|9+|0+/).map(*.chars == 2).any {
            $count++;
        }
        $p = next_password($p);
    }
    say $count;
}

sub part1() {
    # my $input = "172851-675869";
    my $count = 0;
    my $p = next_password(172851);
    while $p < 675869 {
        if $p.match(/(.)$0/) {
            $count++;
        }
        $p = next_password($p);
    }
    say $count;
}

sub next_password ($pass) {
    my @digits = ($pass + 1).Str.comb;
    my $i = @digits.keys.tail(*-1).first: -> $i { @digits[$i] < @digits[$i-1] };
    if $i {
        @digits[$i..*] = @digits[$i-1] xx *;
    }
    return @digits.join.Int;
}
