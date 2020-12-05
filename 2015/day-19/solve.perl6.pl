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


sub solve-part2-breakdown($molecule, %replacements) {
    my %inv-rep;
    for %replacements.keys -> $a {
        for %replacements{$a}.values -> $b {
            die "FAIL" if defined %inv-rep{$b};
            %inv-rep{$b} = $a;
        }
    }

    my @mug;
    @mug.push([ 0, $molecule ]);

    my %seen;
    while (@mug.elems > 0) {
        my ($step, $m) = @mug.pop;

        if ($m eq "e") {
            say "Part 2: $step";
            last;
        }
        my @mug2;

        for %inv-rep.keys -> $b {
            my $i = $m.index($b);
            next unless defined($i);
            my $nm = $m.subst($b, %inv-rep{$b}, :nth(1));
            @mug2.push([$i, $nm]);
        }
        my $nstep = $step + 1;
        @mug2 = @mug2.grep({ !defined(%seen{$_[1]}) && !($_[1].chars > 1 && $_[1].contains("e")) }).unique(:as({ $_[1] })).sort({ $^a[0] <=> $^b[0] }).map({ %seen{$_[1]}=True; [$nstep, $_[1]] });
        @mug.append(@mug2);
    }
    return;
}

sub MAIN {
    my ($molecule, %replacements) = load_input();
    solve-part2-breakdown($molecule, %replacements);
    solve_part1($molecule, %replacements);
}
