sub MAIN  {
    part1;
}

sub part1 {
    my @foods = "input".IO.lines.map(
        -> $line {
            my $ingredients = $line.substr(0, $line.index("\(")).words.Set;
            my $allergens = $line.match(/contains \s ((<[a..z]>+)+ %% ', ')/).[0][0].map(*.Str).Set;

            $%(
                :allergens($allergens),
                :ingredients($ingredients)
            )
        }
    );

    # ⊇
    # ⊃

    my %book;
    for @foods -> $food {
        for $food<allergens>.keys -> $allergen {
            if %book{$allergen}:exists {
                %book{$allergen} ∩= $food<ingredients>;
            } else {
                %book{$allergen} = $food<ingredients>.clone;
            }
        }
    }

    my $c = 0;
    for @foods.map({ .<ingredients>.keys }).flat -> $ingredient {
        if ($ingredient ∈ %book.values.none) {
            $c++;
        }
    }
    say "Part 1: $c";
}
