
sub MAIN ($input = "input.txt"){
    say sum $input.IO.lines.rotor(3).map: -> $rucksack3 {
        prio $rucksack3.map({ .comb.unique }).reduce(&infix:<(&)>).keys.first;
    };
}

sub prio (Str:D $letter --> Int) {
    my $s = $letter.ord - ord("a") + 1;
    return $s if $s > 0;
    return $letter.ord - ord("A") + 27;
}
