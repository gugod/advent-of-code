sub MAIN {
    part1;
}

sub parse-input {
    my $input = "input".IO.slurp;
    my @paragraphs = $input.split("\n\n");
    my @rules = @paragraphs[0].split("\n").map(
        -> $line {
            my $field = $line.substr(0, $line.index(":"));
            my @boundaries = $line.comb(/<digit>+/).map({ .Int }).Array;

            {
                "field" => $field,
                "ranges" => [ @boundaries[0]..@boundaries[1],
                             @boundaries[2]..@boundaries[3] ]
            }
        });
    my @your-ticket = @paragraphs[1].split("\n").tail.split(",").map({ .Int }).Array;
    my @nearby-tickets = @paragraphs[2].split("\n").Array.splice(1).map(
        -> $line {
            $line.split(",").map({ .Int }).Array
        }
    );

    return {
        "rules" => @rules,
        "your-ticket" => @your-ticket,
        "nearby-tickets" => @nearby-tickets,
    }
}

sub part1 {
    my %x = parse-input;
    my @all-ranges = %x<rules>.map({ .<ranges>[*] }).flat;

    my @errors;
    for %x<nearby-tickets>[*] -> @ticket {
        my @err = @ticket.grep(-> $num { $num ~~ none(@all-ranges) });
        @errors.append(@err);
    }

    say "Part 1: " ~ @errors.sum;

}
