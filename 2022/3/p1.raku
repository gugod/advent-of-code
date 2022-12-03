
sub MAIN ($input = "input.txt"){
    say sum $input.IO.lines.map: -> $rucksack {
        my $len := $rucksack.chars / 2;
        my $comp1 := $rucksack.substr(0, $len).comb.unique;
        my $comp2 := $rucksack.substr($len).comb.unique;

        prio(($comp1 ∩ $comp2).keys.first);
    };
}

sub prio ($letter) {
    my $s = $letter.ord - ord("a") + 1;
    return $s if $s > 0;
    return $letter.ord - ord("A") + 27;
}
