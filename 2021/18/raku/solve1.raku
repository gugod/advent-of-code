class SnailfishNum {
    has Int $.value is rw;
    has SnailfishNum $.up is rw;
    has SnailfishNum $.down is rw;
    has SnailfishNum $.tail is rw;
    has SnailfishNum $.head is rw;

    has SnailfishNum $.prev-leaf is rw;
    has SnailfishNum $.next-leaf is rw;

    method is-leaf { $.value.defined }

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
        my @stack;
        @stack.push( $[self,0] );
        while @stack.elems > 0 {
            my ($p, $level) = @stack.pop;
            if $p.value.defined {
                return $p if $p.value > 9;
            }
            if $p.down.defined {
                if $p.down.tail.defined {
                    @stack.push($[ $p.down.tail, $level+1 ]);
                }
                @stack.push($[ $p.down, $level+1 ]);
            }
        }
        return Nil;
    }

    method leftmost-deeply-nested-pair-of-numbers {
        my @stack;
        @stack.push( $[self,0] );
        while @stack.elems > 0 {
            my ($p, $level) = @stack.pop;
            if $p.value.defined && $p.tail && $p.tail.value.defined {
                return $p.up if $level > 4;
            }
            if $p.down.defined {
                if $p.down.tail.defined {
                    @stack.push($[$p.down.tail, $level+1]);
                }
                @stack.push($[$p.down, $level+1]);
            }
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
        say "exploding... " ~ self.gist;
        my $p = $.down.prev-leaf;
        say "... prev-leaf: " ~ $p.gist;
        $p.value += $.down.value if $p;

        $p = $.down.tail.next-leaf;
        $p.value += $.down.tail.value if $p;

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

        $.value = Nil;
        $.down = $h;
    }

    method reduce {
        loop {
            my $p = self.leftmost-deeply-nested-pair-of-numbers;
            if $p {
                $p.explode;
                say "After explode: " ~ self.gist;
                next;
            }

            my $q = self.leftmost-oversized-leaf;
            if $q {
                $q.split;
                say "After split: " ~ self.gist;
            }
            last unless $p || $q;
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
    test-num-seq();
    exit();
    my @s =("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]").map({ parse-snailfish-number($_) });
    my $r = [+] @s;
    say $r;
    $r.reduce;
    say $r;
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
