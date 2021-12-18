class SnailfishNum {
    has Int $.value;
    has SnailfishNum $.up is rw;
    has SnailfishNum $.down is rw;
    has SnailfishNum $.tail is rw;
    has SnailfishNum $.head is rw;

    method is-leaf { $.value.defined }

    method leftmost-deeply-nested-pair-of-numbers {
        my @stack;
        @stack.push([self,0]);
        while @stack.elems > 0 {
            my ($p, $level) = @stack.pop;
            if $p.value.defined && $p.tail.value.defined {
                return $p if $level >= 4;
            }
            if $p.down.defined {
                @stack.push($p, $level+1);
            }
        }
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

    method next-value {
        return Nil unless $.is-leaf;
        return $.tail if $.tail.defined;
        my $p = self;
        $p = $p.up while $p.up && !$p.tail;
        return Nil unless $p.tail;
        $p = $p.tail;
        $p = $p.down until $p.is-leaf;
        return $p;
    }

    method prev-value {
        return Nil unless $.is-leaf;
        my $p = $.head;
        return Nil unless $p;
        $p = $p.down.tail while $p.down;
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
    my $s = parse-snailfish-number("[[[[[9,8],1],2],3],4]");
    say $s;
    say $s.nested-too-deep; # False

    # my $d = $s.down.down.down.down.down;
    my $d = $s.down.tail;
    while $d {
        say $d.gist;
        $d = $d.prev-value;
        # $d = $d.next-value;
    }
}

sub part1 (IO::Path() $input) {
    my @lines = $input.lines;
}
