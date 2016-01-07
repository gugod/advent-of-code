use v6;

my @products = (
    # Weapon
    [['Dagger',      8, 4, 0],
     ['Shortsword', 10, 5, 0],
     ['Warhammer',  25, 6, 0],
     ['Longsword',  40, 7, 0],
     ['Greataxe',   74, 8, 0]],
    # Armor
    [['',            0, 0, 0],
     ['Leather',    13, 0, 1],
     ['Chainmail',  31, 0, 2],
     ['Splintmail', 53, 0, 3],
     ['Bandedmail', 75, 0, 4],
     ['Platemail', 102, 0, 5]],
    # Ring 1
    [['',             0, 0, 0],
     ['Damage +1',   25, 1, 0],
     ['Damage +2',   50, 2, 0],
     ['Damage +3',  100, 3, 0],
     ['Defense +1',  20, 0, 1],
     ['Defense +2',  40, 0, 2],
     ['Defense +3',  80, 0, 3]],
);
# Ring 2
@products[3] = @products[2];

sub price-of {
    my (@purchase) = @_;
    return [+] @purchase.pairs.map: { @products[$_.key][$_.value][1] };
}

sub next-purchase(@purchase is copy) {
    my $carry = 1;
    for 0..3 -> $i {
        @purchase[$i] += $carry;
        if (@purchase[$i] < @products[$i].elems) {
            $carry = 0;
            last;
        } else {
            @purchase[$i] = 0;
        }
    }
    if ($carry == 1) {
        return ();
    }
    return @purchase;
}

sub equip(@purchase, @player is copy) {
    for 0..3 -> $i {
        @player[1] += @products[$i][ @purchase[$i] ][2];
        @player[2] += @products[$i][ @purchase[$i] ][3];
    }
    return @player;
}

sub player-wins(@player, @boss) {
    my $damage-for-boss   = max(1, @player[1] - @boss[2]);
    my $damage-for-player = max(1, @boss[1] - @player[2]);
    my $boss-hp = @boss[0];
    my $player-hp = @player[0];
    my $round = 0;
    while ( ($boss-hp & $player-hp) > 0 ) {
        $player-hp -= $damage-for-player;
        $boss-hp   -= $damage-for-boss;
    }
    return $player-hp > $boss-hp;
}

sub solve-part-one() {
    my @boss = (109, 8, 2);
    my @naked-player = (100, 0, 0);

    my @purchase = (0,0,0,0);

    my $min-gold-spent = Inf;
    while (@purchase) {
        my $gold-spent = price-of(@purchase);
        my @equipped-player = equip(@purchase, @naked-player);
        my $win = player-wins( @equipped-player, @boss );
        # say "$win\t--\t{$gold-spent}\t-- {@purchase} -- {@equipped-player}";
        if ( $win ) {
            if ($gold-spent < $min-gold-spent) {
                $min-gold-spent = $gold-spent;
            }
        }

        @purchase = next-purchase(@purchase);
        while (@purchase && !( @purchase[3] == @purchase[2] == 0 ) && @purchase[3] <= @purchase[2]) {
            @purchase = next-purchase(@purchase);            
        }
    }
    say "Part 1: minimum gold spent = $min-gold-spent";
}

sub MAIN {
    solve-part-one();
}
