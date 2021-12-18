class SnailfishNum {
    has Int $.value;
    has SnailfishNum $.up is rw;
    has SnailfishNum $.down is rw;
    has SnailfishNum $.tail is rw;

    method gist {
        my $str = "";

        if $.down.defined {
            $str ~= "[" ~ $.down.gist ~ "]";
        } else {
            $str ~= $.value;
        }
        if $.tail.defined {
            $str ~= "," ~ $.tail.gist;
        }

        return  $str;
    }
}

multi infix:<+> (SnailfishNum $a, SnailfishNum $b --> SnailfishNum) {
    my $o = SnailfishNum.new(:down($a));
    $a.up = $o;
    $a.tail = $b;
    $b.up = $o;
    return $o;
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
        $h.tail = $t;

        my $o = SnailfishNum.new();
        $t.up = $o;
        $h.up = $o;
        $o.down = $h;

        $/.make: $o;
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

    method num($/) {
        $/.make: SnailfishNum.new( :value( $/.Int) );
    }
}

sub parse-snailfish-number (Str $s) {
    my $parser = SnailfishNumParser.new.parse($s, :actions( SnailfishNumBuilder.new ));
    return $parser.made;
}

sub MAIN (IO::Path() $input) {
    my $s1 = parse-snailfish-number("[1,2]");
    my $s2 = parse-snailfish-number("[3,4]");
    my $s3 = parse-snailfish-number("[5,6]");
    my $s = $s1 + $s2 + $s3;
    say $s.gist;
}

sub part1 (IO::Path() $input) {
    my @lines = $input.lines;
}
