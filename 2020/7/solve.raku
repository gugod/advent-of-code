
my %bags-inside;
my %bags-outside;

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
        %bags-outside{ %it<bag> }{ $theBag } = %it<quant>;
        %bags-inside{ $theBag }{ %it<bag> } = %it<quant>;
    }
}

# Part 1
my $shiny-gold-bag-bags = BagHash.new;

my @bags = %bags-outside{'shiny gold'}.keys.Array;

while @bags.elems > 0 {
    my $bag = @bags.pop;
    $shiny-gold-bag-bags.add($bag);
    if (%bags-outside{$bag}) {
        my @more-bags = %bags-outside{$bag}.keys.grep(
            -> $bag {
                $bag ∉ $shiny-gold-bag-bags
            });
        if @more-bags {
            @bags.append(@more-bags);
        }
    }
}

say "Part 1 = " ~ $shiny-gold-bag-bags.keys.elems;

# Part 2
my $shiny-gold-bag-bagged = BagHash.new;
my $bags = 0;

my @bag-queue = %bags-inside{'shiny gold'}.pairs.map({ %(:factor(1), :quant(.value), :bag(.key)) });

while @bag-queue.elems > 0 {
    my %bag = @bag-queue.shift;
    $shiny-gold-bag-bagged.add(%bag<bag>);

    my $q = %bag<factor> * %bag<quant>;
    $bags += $q;

    my @more = %bags-inside{ %bag<bag> }.pairs.map({ %(:factor($q), :quant(.value), :bag(.key)) });
    if @more {
        @bag-queue.append(@more);
    }
}
say "Part 2 = $bags";
