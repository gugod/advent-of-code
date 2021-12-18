
sub part1 (IO::Path() $input) {
    my @lines = $input.lines;
}

class SnailfishNum {
    has $.head is readonly;
    has $.tail is readonly;

    method gist {
        return ('[', $.head.gist, ',' , $.tail.gist, ']').join("");
    }
}

multi infix:<+> (SnailfishNum $a, SnailfishNum $b --> SnailfishNum) {
    return SnailfishNum.new(:head($a), :tail($b));
}

grammar SnailfishNumParser {
    token TOP { <pair> }
    token pair { '[' <head> ',' <tail> ']' }
    token head { <num-or-pair> }
    token tail { <num-or-pair> }
    token num-or-pair { <num> | <pair> }
    token num { <digit>+ }
}

class SnailfishNumBuilder {
    method TOP ($/) {
        $/.make: $/.<pair>.made;
    }
    method pair($/) {
        my $h = $/.<head>.made;
        my $t = $/.<tail>.made;
        $/.make: SnailfishNum.new(:head($h), :tail($t));
    }

    method head($/) { $/.make: $/.<num-or-pair>.made }
    method tail($/) { $/.make: $/.<num-or-pair>.made }

    method num-or-pair ($/) {
        if $/.<pair> {
            $/.make: $/.<pair>.made;
        } else {
            $/.make: $/.<num>.made;
        }
    }

    method num($/) { $/.make: $/.Int }
}

sub parse-snailfish-number (Str $s) {
    my $parser = SnailfishNumParser.new.parse($s, :actions( SnailfishNumBuilder.new ));
    return $parser.made;
}

sub MAIN (IO::Path() $input) {
    my $s1 = parse-snailfish-number("[1,2]");
    my $s2 = parse-snailfish-number("[3,4]");

    say $s1 + $s2;
}
