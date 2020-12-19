
use MIBGrammar;

# 0: 4 1 5
# 1: 2 3 | 3 2
# 2: 4 4 | 5 5
# 3: 4 5 | 5 4
# 4: "a"
# 5: "b"

sub MAIN {
    example();
    part1();
}

grammar ExampleMessageGrammerFromMythicalInformationBureau {
    token TOP { <r4> <r1> <r5> }
    token r1 { <r2> <r3> | <r3> <r2> }
    token r2 { <r4> <r4> | <r5> <r5> }
    token r3 { <r4> <r5> | <r5> <r4> }
    token r4 { "a" }
    token r5 { "b" }
};

sub example {
    my @messages = (
        "ababbb",
        "bababa",
        "abbbab",
        "aaabbb",
        "aaaabbb",
    );

    my $parsables = 0;
    for @messages -> $m {
        my $parsed = ExampleMessageGrammerFromMythicalInformationBureau.parse($m);
        if $parsed.defined {
            $parsables++;
            say "parsable: $m";
        } else {
            say "imparsable: $m";
        }
    }
    say $parsables;
}

sub part1 {
    my @messages = "input".IO.slurp.split("\n\n").tail.split("\n");

    my $parsables = 0;
    for @messages -> $m {
        my $parsed = MIBGrammar.parse($m);
        if $parsed {
            $parsables++;
            say "parsable - $m";
        } else {
            say "imparsable - $m";
        }
    }
    say $parsables;
}
