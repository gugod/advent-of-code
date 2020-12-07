
my %bags-in-bag;

for "input".IO.lines -> $line {
    my $match = $line.match(
        /^
        $<theBag>=( <alpha>+ \s <alpha>+) \s bags \s contain
        $<inside>=(
            ( \s no \s other \s bags . )
            || $<bags>=(\s+ (<digit>+) \s+ (<alpha>+ \s <alpha>+) \s bags? <[,.]> )+
        )
        $/
    );

    unless $match {
        die "Unrecognized line: $line";
    }

    my $theBag = $match<theBag>.Str;
    my @bags-inside = $match<inside><bags>.map({ %( :quant(.[0].Int), :bag(.[1].Str) ) });

    for @bags-inside -> %it {
        %bags-in-bag{ %it<bag> }{ $theBag } = %it<quant>;
    }
}

# Part 1
my $shiny-gold-bag-bags = BagHash.new;

my @bags = %bags-in-bag{'shiny gold'}.keys.Array;

while @bags.elems > 0 {
    my $bag = @bags.pop;
    $shiny-gold-bag-bags.add($bag);
    if (%bags-in-bag{$bag}) {
        my @more-bags = %bags-in-bag{$bag}.keys.grep(
            -> $bag {
                $bag ∉ $shiny-gold-bag-bags
            });
        if @more-bags {
            @bags.append(@more-bags);
        }
    }
}

say $shiny-gold-bag-bags.keys.elems;
