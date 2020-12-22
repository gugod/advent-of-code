sub MAIN {
    part1;
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
