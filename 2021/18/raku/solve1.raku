class SnailfishNum {
    has Int $.value is rw;
    has SnailfishNum $.up is rw;
    has SnailfishNum $.down is rw;
    has SnailfishNum $.tail is rw;
    has SnailfishNum $.head is rw;

    has SnailfishNum $.prev-leaf is rw;
    has SnailfishNum $.next-leaf is rw;

    method magnitude {
        return $.value if self.is-leaf;
        return 3 * $.down.magnitude + 2 * $.down.tail.magnitude;
    }

    method is-leaf { $.value.defined }

    method level {
        my $level = -1;
        my $p = self;
        while $p {
            $level++;
            $p = $p.up;
        }
        return $level;
    }

    method leftmost-leaf {
        my $p = self;
        $p = $p.down while $p.down.defined;
        return $p;
    }

    method rightmost-leaf {
        my $p = self;
        $p = $p.down.tail while $p.down.defined;
        return $p;
    }

    method leftmost-pair {
        my $p = self.leftmost-leaf;
        my $q = $p.tail;

        until $q.is-leaf {
            $p = $p.next-leaf;
            $q = $p.tail;
        }

        return $p.up;
    }

    method next-pair {
        return Nil if self.is-leaf;

        my $p = self.down.tail.next-leaf;

        while $p {
            if $p.tail && $p.tail.is-leaf {
                return $p.up;
            }
            $p = $p.next-leaf;
        }

        return Nil;
    }

    method all-oversized-leaf {
        my $p = self.leftmost-leaf;
        my @ret;

        while $p {
            @ret.push($p) if $p.value > 9;
            $p = $p.next-leaf;
        }

        return @ret;
    }

    method leftmost-oversized-leaf {
        my $p = self.leftmost-leaf;
        while $p {
            return $p if $p.value > 9;
            $p = $p.next-leaf;
        }
        return Nil;
    }

    method leftmost-deeply-nested-pair-of-numbers {
        my $p = self.leftmost-pair;

        while $p {
            if $p.level >= 4 {
                return $p;
            }
            $p = $p.next-pair;
        }

        return Nil;
    }

    method nested-too-deep {
        my $level = 0;
        my $p = self;
        while $p.up {
            $level++;
            $p = $p.up;
        }
        return $level >= 4;
    }

    method explode {
        # Only works when invoked on the node that holds 2 leaf nodes.
        return Nil unless $.down.defined && $.down.value.defined && $.down.tail.value.defined;
        my $p = $.down.prev-leaf;
        my $q = $.down.tail.next-leaf;
        if $p {
            $p.value += $.down.value;
            $p.next-leaf = self;
            $.prev-leaf = $p;
        }
        if $q {
            $q.value += $.down.tail.value;
            $q.prev-leaf = self;
            $.next-leaf = $q;
        }
        $.down = Nil;
        $.value = 0;
    }

    method split {
        # Only works on a leaf node.
        return Nil unless $.value;
        my $a = $.value div 2;
        my $b = $.value - $a;

        my $h = SnailfishNum.new( :value($a), :up(self) );
        my $t = SnailfishNum.new( :value($b), :up(self) );
        $h.tail = $t;
        $t.head = $h;
        $h.next-leaf = $t;
        $t.prev-leaf = $h;
        $h.prev-leaf = $.prev-leaf;
        $t.next-leaf = $.next-leaf;

        $.prev-leaf.next-leaf = $h if $.prev-leaf;
        $.next-leaf.prev-leaf = $t if $.next-leaf;

        $.down = $h;
        $.prev-leaf = Nil;
        $.next-leaf = Nil;
        $.value = Nil;
    }

    method reduce {
        my $c = 1;
        while $c != 0 {
            $c = 0;
            my $p = self.leftmost-deeply-nested-pair-of-numbers;
            if $p {
                $p.explode;
                $c += 1;
            }

            if $c == 0 {
                my $q = self.leftmost-oversized-leaf;
                if $q {
                    $q.split;
                    $c++;
                }
            }
        }
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
    $a.rightmost-leaf.next-leaf = $b.leftmost-leaf;
    $b.leftmost-leaf.prev-leaf = $a.rightmost-leaf;
    $o.reduce;
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

        $h.rightmost-leaf.next-leaf = $t.leftmost-leaf;
        $t.leftmost-leaf.prev-leaf = $h.rightmost-leaf;

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
    my @s = $input.lines.map(&parse-snailfish-number);
    my $r = [+] @s;
    say $r.magnitude;
}

sub test-reduce2 {
    my $s = parse-snailfish-number("[[[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],[[[5,[2,8]],4],[5,[[9,9],0]]]],[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]]");
    say $s;
    $s.reduce;
    say $s;
}

sub test-magnitude {
    for (
        ["[[1,2],[[3,4],5]]", 143],
        ["[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384],
        ["[[[[1,1],[2,2]],[3,3]],[4,4]]", 445],
        ["[[[[3,0],[5,3]],[4,4]],[5,5]]", 791],
        ["[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137],
        ["[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", 3488],
    ) -> [$str, $expected] {
        my $s = parse-snailfish-number($str);
        my $m = $s.magnitude();
        say ($m == $expected ?? "ok" !! "not ok") ~ " $m vs $expected <- $str";
    }
}

sub test-level {
    my $s = parse-snailfish-number("[10,[20,30]]");
    my $p = $s.leftmost-leaf;
    while $p {
        say $p.value;
        say $p.level;
        $p = $p.next-leaf;
    }
}

sub test-inspect2 {
    my @s =("[[[0,7],4],[7,[[8,4],9]]]", "[1,1]").map({ parse-snailfish-number($_) });
    my $r = [+] @s;
    say $r.gist;

    say "# Leftmost pair";
    my $p = $r.leftmost-pair;
    say $p.gist;

    say "# The next pair";
    $p = $p.next-pair;
    say $p.gist;
}

sub test-inspect1 {
    my $s = parse-snailfish-number("[[[[0,7],4],[7,[[8,4],9]]],[1,1]]");
    say $s.gist;
    my $p = $s.leftmost-leaf;
    while $p {
        say $p.value ~ "\t" ~ $p.level;
        $p = $p.next-leaf;
    }
    say "# Explode this";
    say $s.leftmost-deeply-nested-pair-of-numbers.gist;
}

sub inspect-right-to-left (SnailfishNum $s){
    my $p = $s.rightmost-leaf;
    my @out;
    while $p {
        @out.push($p.value);
        $p = $p.prev-leaf;
    }
    say @out.gist;
}

sub inspect-left-to-right (SnailfishNum $s){
    my $p = $s.leftmost-leaf;
    my @out;
    while $p {
        @out.push($p.value);
        $p = $p.next-leaf;
    }
    say @out.gist;
}

sub test-reduce {
    my @s =("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]").map({ parse-snailfish-number($_) });
    my $r = [+] @s;

    # my $r = parse-snailfish-number("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]");

    say "r: " ~ $r.gist;
    $r.reduce;
    say "after reduce: " ~ $r.gist;
    inspect-right-to-left($r);
    inspect-left-to-right($r);
}

sub test-num-seq {
    my $s1 = parse-snailfish-number("[[[0,7],4],[7,[[8,4],9]]]");
    my $s2 = parse-snailfish-number("[1,1]");
    my $s = $s1 + $s2;
    say $s.gist;

    my $p = $s.leftmost-leaf;
    my @leaf := [];
    while $p {
        @leaf.push($p);
        $p = $p.next-leaf;
    }
    say @leaf.gist;

    $p = $s.rightmost-leaf;
    @leaf = [];
    while $p {
        @leaf.push($p);
        $p = $p.prev-leaf;
    }
    say @leaf.gist;
}

sub part1 (IO::Path() $input) {
    my @lines = $input.lines;
}
