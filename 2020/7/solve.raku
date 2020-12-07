
my %bags-in-bag;

for "input".IO.lines -> $line {
    my @bags = $line.comb(
        /<alpha>+ \s <alpha>+ \s bags?/
    ).map({ .subst(/\s bags?$/) });

    if @bags.elems > 1 {
        my $theBag = @bags.shift;
        for @bags -> $bag {
            %bags-in-bag{ $bag }.push: $theBag;
        }
    } else {
        say "Unparsable input: $line";
    }
}

my $shiny-gold-bag-bags = BagHash.new;

my @bags = %bags-in-bag{'shiny gold'}.Array;

while @bags.elems > 0 {
    my $bag = @bags.pop;
    $shiny-gold-bag-bags.add($bag);

    if (%bags-in-bag{$bag}) {
        my @more-bags = %bags-in-bag{$bag}.grep(
            -> $bag {
                $bag ∉ $shiny-gold-bag-bags
            });
        if @more-bags {
            @bags.append(@more-bags);
        }
    }
}

say $shiny-gold-bag-bags.raku;
say $shiny-gold-bag-bags.keys.elems;
