grammar MIBGrammarGrammar {
    token TOP { <def>+ }
    token def { <defab> | <defr1> | <defr2> }
    token defab {
        <num> ":" " "+ <ab> "\n"
    }
    token defr1 {
        (<num>) ":" " "+ ( <num> +%' ' ) "\n"
    }
    token defr2 {
        (<num>) ":" " "+ (( ' '* <num> +%' ' ' '* ) +% '|') "\n"
    }
    token ab { '"a"' | '"b"' }
    token num { <digit>+ }
}

class GenMIBGrammar {
    has $.name = "MIBGrammar";
    method TOP($match) {
        $match.make(
            "grammar { $!name } \{"
            ~ $match<def>>>.made
            ~ "\}\n"
        );
    }

    method def($/) {
        if $<defab> {
            make $<defab>.made;
        } elsif $<defr1> {
            make $<defr1>.made;
        } elsif $<defr2> {
            make $<defr2>.made;
        }
    }

    method defab($/) {
        make("\n    token r" ~ $/<num> ~ " \{ " ~ $/<ab> ~ " \}\n");
    }

    method defr1($/) {
        my $deffor = $/[0];
        my @defwith = $/[1].split(" ").map(-> $num { "<r" ~ $num ~ ">" });
        if $deffor eq "0" {
            make("\n    token TOP \{ { @defwith.join(" ") } \}\n");
        } else {
            make("\n    token r$deffor \{ { @defwith.join(" ") } \}\n");
        }
    }

    method defr2($match) {
        my $deffor = $match[0];
        my $defwith = $match[1].Str.subst(/$<n>=( <digit>+ )/, { "<r" ~ $<n> ~ ">" }, :g);
        if $deffor eq "0" {
            $match.make("\n    token TOP \{ $defwith \}\n");
        } else {
            $match.make("\n    token r$deffor \{ $defwith \}\n");
        }
    }
}

# my $parsed = MIBGrammarGrammar.parse('5: 1 | 21
# 2: "b"
# 1: "a"
# ', actions => GenMIBGrammar.new);

my $rules;
my $parsed;

$rules = "input-example-part2".IO.slurp.split("\n\n").head ~ "\n";
$parsed = MIBGrammarGrammar.parse($rules, actions => GenMIBGrammar.new(:name("MIBGrammarExamplePart2")));

if $parsed {
    "MIBGrammarExamplePart2.pm6".IO.spurt( $parsed.made );
    say "OK -- MIBGrammarExamplePart2.pm6 is generated.";
} else {
    say "Falied";
}


$rules = "input".IO.slurp.split("\n\n").head ~ "\n";
$parsed = MIBGrammarGrammar.parse($rules, actions => GenMIBGrammar.new);

if $parsed {
    "MIBGrammar.pm6".IO.spurt( $parsed.made );
    say "OK -- MIBGrammar.pm6 is generated.";
} else {
    say "Falied";
}
