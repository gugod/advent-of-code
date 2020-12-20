
use MIBGrammar;
use MIBGrammarV2;
use MIBGrammarExamplePart1;
use MIBGrammarExamplePart2;
use MIBGrammarExamplePart2Alt;

sub MAIN {
    example-part1();
    example-part2();
    example-part2-alt();
    # example();
    # part1();
    # part2();
}

sub count-parsables(@messages, $grammar, $debug = False) {
    my $parsables = 0;
    for @messages -> $m {
        my $parsed = $grammar.parse($m);
        if $parsed {
            $parsables++;
            say "    parsable - $m" if $debug;
        } else {
            say "    imparsable - $m" if $debug;
        }
    }
    return $parsables;
}

sub example-part1 {
    my @messages = (
        "ababbb",
        "bababa",
        "abbbab",
        "aaabbb",
        "aaaabbb",
    );

    my $parsables = count-parsables(@messages, MIBGrammarExamplePart1.new);
    say "Example in Part 1: $parsables";
}

sub part1 {
    my @messages = "input".IO.slurp.split("\n\n").tail.split("\n");
    my $parsables = count-parsables(@messages, MIBGrammar.new);
    say "Part 1: $parsables";
}

sub part2 {
    my @messages = "input".IO.slurp.split("\n\n").tail.split("\n");
    my $parsables = count-parsables(@messages, MIBGrammarV2.new);
    say "Part 2: $parsables";
}

sub example-part2 {
    my @messages = "input-example-part2".IO.slurp.split("\n\n").tail.split("\n");
    my $parsables = count-parsables(@messages, MIBGrammarExamplePart2.new);
    say "Example in Part 2: $parsables";
}

sub example-part2-alt {
    my @messages = "input-example-part2".IO.slurp.split("\n\n").tail.split("\n");
    my $parsables = count-parsables(@messages, MIBGrammarExamplePart2Alt.new, True);
    say "Example in Part 2 (Alt): $parsables";
}
