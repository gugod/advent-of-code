sub MAIN {
    # part1;
    part2;
}

sub parse-input {
    my $input = "input".IO.slurp;
    my @paragraphs = $input.split("\n\n");
    my @rules = @paragraphs[0].split("\n").map(
        -> $line {
            my $field = $line.substr(0, $line.index(":"));
            my @boundaries = $line.comb(/<digit>+/).map({ .Int });

            {
                "field" => $field,
                "ranges" => [ @boundaries[0]..@boundaries[1],
                             @boundaries[2]..@boundaries[3] ]
            }
        });
    my @your-ticket = @paragraphs[1].split("\n").tail.split(",").map({ .Int });
    my @nearby-tickets = @paragraphs[2].split("\n").Array.splice(1).map(
        -> $line {
            $line.split(",").map({ .Int })
        }
    );

    return {
        "rules" => @rules,
        "your-ticket" => @your-ticket,
        "nearby-tickets" => @nearby-tickets,
    }
}

sub part1 {
    my %mystery = parse-input;
    my @all-ranges = %mystery<rules>.map({ .<ranges>[*] }).flat;

    my @noerr-tickets;
    my @errors;
    for %mystery<nearby-tickets>[*] -> @ticket {
        my @err = @ticket.grep(-> $num { $num ~~ none(@all-ranges) });
        @errors.append(@err);
        if @err.elems == 0 {
            @noerr-tickets.push: @ticket;
        }
    }

    say "Part 1: " ~ @errors.sum;

    return {
        "rules" => %mystery<rules>,
        "your-ticket" => %mystery<your-ticket>,
        "nearby-tickets" => @noerr-tickets,
    }
}

sub part2 {
    my %mystery = part1;

    my %mystery-part2;

    my $fields = %mystery<your-ticket>.elems;

    for ^$fields -> $i {
        # say "Solving field $i";
        my @nums = %mystery<nearby-tickets>.map({ .[$i] });

        my @candidates = %mystery<rules>.grep(
            -> %rule {
                @nums.map(
                    -> $n {
                        $n ~~ any(%rule<ranges>[*])
                    }
                ).all
            });

        die "game over\n" unless @candidates.defined;

        for @candidates -> %rule {
            %mystery-part2{ %rule<field> }.push: $i;
        }
    }


    my %mystery-solved;
    while %mystery-part2.keys > 0 {
        my $x = %mystery-part2.pairs.first({ .value.elems == 1 });
        unless $x.defined {
            die "Gamee over";
        }

        my $field_name = $x.key;
        my $field_index = $x.value[0];

        say "    " ~ $field_name ~ " must be index " ~ $field_index;
        %mystery-solved{ $field_name } = $field_index;

        # This looks so weird
        %mystery-part2{ $field_name }:delete;

        for %mystery-part2.pairs {
            %mystery-part2{ .key } = .value.grep(-> $n { $n != $field_index });
        }
    }

    my @departure_fields = %mystery-solved.pairs.grep({ .key ~~ /^departure/ }).map({ .value });
    say "Part 2: " ~ [*] %mystery<your-ticket>[@departure_fields];

}
