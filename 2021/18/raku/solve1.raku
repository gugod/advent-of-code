class SnailfishNum {
    has Int $.value;
    has SnailfishNum $.up is rw;
    has SnailfishNum $.down is rw;
    has SnailfishNum $.tail is rw;
    has SnailfishNum $.head is rw;

    method next-value {
        return Nil unless $.value;
        return $.tail if $.tail.defined;
        my $p = self;
        $p = $p.up while $p.up && !$p.tail;
        return Nil unless $p.tail;
        $p = $p.tail;
        $p = $p.down until $p.value.defined;
        return $p;
    }

    method prev-value {
        return Nil unless $.value;
        return $.head if $.head.defined;
        my $p = self;
        $p = $p.up while $p.up && !$p.head;
        return Nil unless $p.head;
        $p = $p.head;
        $p = $p.down.tail until $p.value.defined;
        return $p;
    }

    method gist {
        return $.value if $.value.defined;
        return "[" ~ $.down.gist ~ "," ~ $.down.tail.gist ~ "]";
    }
}

multi infix:<+> (SnailfishNum $a, SnailfishNum $b --> SnailfishNum) {
    my $o = SnailfishNum.new(:down($a));
    $a.up = $o;
    $a.tail = $b;
    $b.head = $a;
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
        $t.head = $h;

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

    say "# next-value";
    my $n = $s.down.down.down;
    while $n.defined {
        say $n.gist;
        $n = $n.next-value;
    }

    say "# prev-value";
    $n = $s.down.tail.down.tail;
    while $n.defined {
        say $n.gist;
        $n = $n.prev-value;
    }
}

sub part1 (IO::Path() $input) {
    my @lines = $input.lines;
}
