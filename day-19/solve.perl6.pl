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

sub solve_part1($molecule, %replacements) {
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

sub solve_part2_breakdown($molecule, %replacements) {
    my %inv_replacements;
    for %replacements.keys -> $a {
        for %replacements{$a}.values -> $b {
            %inv_replacements{$b} = $a;
        }
    }

    my @inv_keys = %inv_replacements.keys.sort: { $^b.chars <=> $^a.chars };

    my @mug;
    @mug.push([0, $molecule]);
    my $minstep = Inf;
    my $iter = 0;
    while (@mug.elems > 0) {
        my ($step, $m) = @mug.pop;
        say "{$iter++}\t{@mug.elems} ==> $step\t$m";
        if ($m eq "e") {
            if ($minstep < $step) {
                $minstep = $step;
            }
        }
        for @inv_keys -> $b {
            my $a = %inv_replacements{$b};
            my @loc = locations_of($m, $b);
            for @loc -> $loc {
                my $nm = $m.substr(0, $loc) ~ $a ~ $m.substr($loc + $b.chars);
                @mug.push([$step+1, $nm]);
            }
        }
    }
    say "Part 2: $minstep";
}

sub solve_part2_buildup($molecule, %replacements) {
    my @mug;
    @mug.push([0, "e"]);
    my $minstep = Inf;
    my $iter = 0;
    while (@mug.elems > 0) {
        my ($step, $m) = @mug.shift;
        say "{$iter++}\t{@mug.elems} ==> $step\t$m";
        if ($m eq $molecule) {
            if ($minstep < $step) {
                $minstep = $step;
            }
        }

        for %replacements.keys -> $a {
            for %replacements{$a}.values -> $b {
                my @loc = locations_of($m, $a);
                for @loc -> $loc {
                    my $nm = $m.substr(0, $loc) ~ $b ~ $m.substr($loc + $a.chars);
                    next if $nm.chars > $molecule.chars;
                    @mug.push([$step+1, $nm]);
                }
            }
        }
    }
    say "Part 2: $minstep";
}

sub MAIN {
    my ($molecule, %replacements) = load_input();
    solve_part1($molecule, %replacements);

    # solve_part2_breakdown($molecule, %replacements);
    solve_part2_buildup($molecule, %replacements);
}
