sub MAIN {
    # part1;
    part2;
}

sub part2 {
    my @decks = "input".IO.slurp.split("\n\n").map(
        {
            .split("\n").tail(*-1).grep({ $^x ne "" }).map({ .Int }).Array
        }
    );

    my ($winner, $score) = play-recursive-combat(@decks[0], @decks[1], 1);
    my $winner-deck = $winner == 1 ?? @decks[0] !! @decks[1];

    say "Part 2: $score";
}

sub play-recursive-combat(@deck1, @deck2) {
    my $seen = SetHash.new;
    my $round = 1;
    while @deck1.elems > 0 and @deck2.elems > 0 {
        my $game = @deck1.join(",") ~ " vs " ~ @deck2.join(",");
        return 1 if $seen{$game};
        $seen.set($game);
        $round++;

        my $player1-card = @deck1.shift;
        my $player2-card = @deck2.shift;

        my $winner;

        if $player1-card <= @deck1.elems and $player2-card <= @deck2.elems {
            ($winner, my $score) = play-recursive-combat(@deck1.head($player1-card), @deck2.head($player2-card), $game-num + 1);
        } else {
            $winner = $player1-card < $player2-card ?? 2 !! 1;
        }

        if $winner == 1 {
            @deck1.push($player1-card);
            @deck1.push($player2-card);
        }
        else {
            @deck2.push($player2-card);
            @deck2.push($player1-card);
        }
    }

    my ($winner, $winner-deck);

    if @deck1.elems < @deck2.elems {
        $winner = 2;
        $winner-deck = @deck2;
    } else {
        $winner = 1;
        $winner-deck = @deck1;
    }

    my $score = ($winner-deck >>*>> ((1..$winner-deck.elems).reverse)).sum;
    return ($winner, $score);
}

sub part1 {
    my @decks = "input".IO.slurp.split("\n\n").map(
        {
            .split("\n").tail(*-1).grep({ $^x ne "" }).map({ .Int }).Array
        }
    );

    my $round = 1;
    while @decks.map({ .elems }).all > 0 {
        say "-- Round $round --";
        say "Player 1 Deck: " ~ @decks[0];
        say "Player 2 Deck: " ~ @decks[1];
        $round++;

        my $player1-card = @decks[0].shift;
        my $player2-card = @decks[1].shift;

        if $player1-card > $player2-card {
            @decks[0].push($player1-card);
            @decks[0].push($player2-card);
        }
        elsif $player2-card > $player1-card {
            @decks[1].push($player2-card);
            @decks[1].push($player1-card);
        }
        else {
            die 'game over?';
        }
    }

    say "-- Game over --";
    say "Player 1 Deck: " ~ @decks[0];
    say "Player 2 Deck: " ~ @decks[1];

    my $winner-deck = @decks.first({ .elems > 0 });
    say $winner-deck;
    my $score = ($winner-deck >>*>> ((1..$winner-deck.elems).reverse)).sum;
    say "Part 1: $score";
}
