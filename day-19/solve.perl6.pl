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

sub common_prefix_length(Str $a, Str $b) {
    return (1..([min] $a.chars, $b.chars)).reverse.first({ $a.substr(0,$_) eq $b.substr(0,$_) })//-Inf;
}

sub common_suffix_length(Str $a, Str $b) {
    return common_prefix_length($a.flip, $b.flip);
}


sub solve_part2_buildup($molecule, %replacements) {
    my @mug;
    @mug.push([0, "e", 0, 0]);

    my $minstep = Inf;
    my $iter = 0;
    my $solutions = 0;
    my $t = time;
    my %seen;

    my $known_common_prefix_length = -Inf;
    my $known_common_suffix_length = -Inf;
    while ( @mug.elems > 0) {
        my ($step, $m, $cpl, $csl) = @mug.shift;
        $iter++;

        if ($m.chars == $molecule.chars && $m eq $molecule) {
            $solutions++;
            if ($minstep > $step) {
                $minstep = $step;
            }
            say "$iter: $step \{$known_common_prefix_length $known_common_suffix_length\} {@mug.elems}";
            say "^^^^^^^^ SOLUTION ^^^^^^^^";
        } else {
            if ( $cpl == $known_common_prefix_length || $csl == $known_common_suffix_length ) {
                say "$iter: $step \{$known_common_prefix_length,$known_common_suffix_length\} ($cpl,$csl) {@mug.elems} = $m";
            }
        }

        for %replacements.keys -> $a {
            for %replacements{$a}.values -> $b {
                my @loc = locations_of($m, $a);
                for @loc -> $loc {
                    my $nm = $m.substr(0, $loc) ~ $b ~ $m.substr($loc + $a.chars);
                    next if %seen{$nm};
                    if ($nm.chars <= $molecule.chars) {
                        my $common_prefix_length = common_prefix_length($nm, $molecule);
                        my $common_suffix_length = common_suffix_length($nm, $molecule);
                        my $good = False;
                        if ($common_suffix_length >= $known_common_suffix_length) {
                            $known_common_suffix_length = $common_suffix_length;
                            $good = True;
                        }
                        if ($common_prefix_length >= $known_common_prefix_length) {
                            $known_common_prefix_length = $common_prefix_length;
                            $good = True;
                        }

                        if ($good) {
                            if ( ($common_prefix_length > $known_common_prefix_length) || ($common_suffix_length > $known_common_suffix_length) ) {
                                @mug.unshift([$step+1, $nm, $common_prefix_length, $common_suffix_length]);
                            } else {
                                @mug.push([$step+1, $nm, $common_prefix_length, $common_suffix_length]);
                            }
                            %seen{$nm} = True;
                        }
                    }
                }
            }
        }
    }
    say "[Buildup] Part 2: $minstep ({time - $t}s, $solutions solutions)";
}

sub MAIN {
    my ($molecule, %replacements) = load_input();
    solve_part2_buildup($molecule, %replacements);
    # solve_part1($molecule, %replacements);

}
