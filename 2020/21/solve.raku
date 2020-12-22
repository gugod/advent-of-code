sub MAIN  {
    part2(part1());
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

    # 'Set' refer to the type of values in the %book
    my Set %book = Hash.new;
    for @foods -> $food {
        for $food<allergens>.keys -> $allergen {
            if %book{$allergen}:exists {
                %book{$allergen} ∩= $food<ingredients>;
            } else {
                %book{$allergen} = $food<ingredients>.clone;
            }
        }
    }

    my @inert;
    my $c = 0;
    for @foods.map({ .<ingredients>.keys }).flat -> $ingredient {
        if ($ingredient ∈ %book.values.none) {
            @inert.push($ingredient);
            $c++;
        }
    }
    say "Part 1: $c";

    return %( :foods(@foods), :inert( @inert.Set ), :book(%book) );
}

sub part2 (%info) {
    my @foods = %info<foods>;
    my $inert = %info<inert>;
    my %book  = %info<book>;

    my Set $all-ingredients = [∪] %book.values;

    my %book2;

    while %book.elems > 0 {
        my %found;
        for %book.pairs.grep({ .value.keys.elems == 1 }) -> $it {
            my $ingredient = $it.value.keys.head;
            my $allergen = $it.key;
            %found{$ingredient} = $allergen;
        }

        for $all-ingredients.keys -> $ingredient {
            my @it = %book.pairs.grep({ $ingredient ∈ .value });
            if @it.elems == 1 {
                %found{$ingredient} = @it[0].key;
            }
        }

        for %found.kv -> $ingredient, $allergen {
            %book2{$ingredient} = $allergen;
            %book{$allergen}:delete;
            for %book.keys -> $k {
                %book{$k} (-)= Set.new($ingredient);
            }
        }
    }

    say %book2;

    say "Part 2: " ~ (%book2.pairs.sort({ $^a.value cmp $^b.value })).map({ .key }).join(",");
}
