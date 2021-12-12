# Hit Points: 51
# Damage: 9

constant @SPELLS = (
    # Name, -Mana, 2:Damage, 3:Heal, 4:Turns, 5:+Armor, 6:+Damage, 7:+Mana
    [ "Magic Missile", 53, 4, 0, 0, 0, 0, 0],
    [ "Drain",         73, 2, 2, 0, 0, 0, 0],
    [ "Shield",       113, 0, 0, 6, 7, 0, 0],
    [ "Poison",       173, 0, 0, 6, 0, 3, 0 ],
    [ "Recharge",     229, 0, 0, 5, 0, 0, 101 ],
);


sub feasible-actions ( %game ) {
    return gather {
        take slip @SPELLS.pairs.grep(
            {
                .value.[1] <=  %game<player-mana> &&
                ! %game{"effects-timer-" ~ .value.[0] }
            }
        ).keys;
    };
}

sub play-one-round ( %game is copy, $action ) {
    for (0, 1) -> $turn {
        my $effect-armor = 0;
        ## apply effect
        for 2,3,4 -> $i {
            if %game{"effects-timer-$i"} > 0 {
                if @SPELLS[$i][5] > 0 {
                    $effect-armor = @SPELLS[$i][5];
                }

                %game<boss-hp> -= @SPELLS[$i][6];
                %game<player-mana> += @SPELLS[$i][7];
                %game{"effects-timer-$i"} -= 1;
            }
        }

        last if %game<boss-hp> <= 0;

        given $turn {
            # Player
            when 0 {
                %game<log> ~= $action;
                my $spell = @SPELLS[$action];

                # Instant
                %game<stats-mana>  += $spell[1];
                %game<player-mana> -= $spell[1];
                %game<boss-hp>     -= $spell[2];
                %game<player-hp>   += $spell[3];

                # Effect
                if $spell[4] > 0 {
                    %game{"effects-timer-" ~ $action} = $spell[4];
                }
            }
            # Boss
            when 1 {
                %game<player-hp> -= %game<boss-damage> - $effect-armor;
            }
        }
    }

    return %game;
}

sub MAIN {
    my %game = (
        :player-hp(50),
        :player-mana(500),
        :boss-hp(51),
        :boss-damage(9),

        # :player-hp(10),
        # :player-mana(250),
        # :boss-hp(13),
        # :boss-damage(8),

        :stats-mana(0),
        :log(""),
        "effects-timer-2" => 0,
        "effects-timer-3" => 0,
        "effects-timer-4" => 0,
    );

    my $mana-spent-minimum = Inf;
    my @mana-spent;
    my @stack;
    @stack.push(%game);

    while @stack.elems > 0 {
        my %game = @stack.pop;

        if %game<stats-mana> > $mana-spent-minimum {
            next;
        }

        # say " ... " ~ %game<log> ~ " ... " ~ join(",", %game<player-hp boss-hp player-mana >);

        if %game<boss-hp> <= 0 && %game<player-hp> > 0 {
            say "player win: " ~ %game<log> ~ " mana spent: " ~ %game<stats-mana>;
            @mana-spent.push: %game<stats-mana>;
            if %game<stats-mana> < $mana-spent-minimum {
                $mana-spent-minimum = %game<stats-mana>;
                say " ... new min: " ~ $mana-spent-minimum;
            }
        }
        elsif %game<player-hp> <= 0 && %game<boss-hp> > 0 {
            # say "  boss win:" ~ %game<log>;
        }

        if (%game<player-hp>, %game<boss-hp>).all > 0 {
            for feasible-actions(%game) -> $action {
                my %nextGame = play-one-round(%game, $action);
                @stack.push(%nextGame);
            }
        }
    }

    say @mana-spent.min();

}
