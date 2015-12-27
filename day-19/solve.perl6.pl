use v6;

sub load_input {
    my %replacements;
    my @input = open("input").lines;
    my $molecule = @input.pop;
    @input.pop;
    for (@input) {
        my ($a,$b) = .split(/ \s* \=\> \s* /);
        %replacements{$a}.push($b);
    }
    return ($molecule, %replacements);
}

sub locations_of {
    my ($str1, $str2) = @_;
    my @loc = ();

    my $offset = 0;
    my Int $i = $str1.index($str2, $offset);
    while (defined($i)) {
        @loc.push($i);
        $offset = $i + $str2.chars;
        $i = $str1.index($str2, $offset);
    }
    return @loc;
}

sub MAIN {
    my ($molecule, %replacements) = load_input();
    my $total = 0;
    my $new_molecules = SetHash.new();
    for %replacements.keys -> $a {
        if ($molecule.contains($a)) {
            my @loc = locations_of($molecule, $a);
            for @loc -> $loc {
                for %replacements{$a}.values -> $b {
                    my $new_molecule = $molecule.substr(0, $loc)  ~ $b ~ $molecule.substr($loc + $a.chars);
                    $new_molecules{$new_molecule} = 1;
                    $total++;
                }
            }
        }        
    }
    say "Part 1: {$new_molecules.elems}";
}
