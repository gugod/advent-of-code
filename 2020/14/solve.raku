
sub MAIN {
#    part1();
    part2();
}

class MachineV2 {
    has @.mask;
    has Int %.memory;

    method run-instruction(Str $instruction) {
        given $instruction {
            when /^ mask \s+ \= / {
                my $mask = $instruction.comb(/<[01X]>+/).first.Str;
                self.update-mask($mask);
            }
            when /^ mem / {
                my ($slot, $value) = $instruction.comb(/<digit>+/).map: *.Int;
                self.update-memory($slot, $value);
            };
        }
    }

    method update-mask (Str $mask) {
        @!mask = $mask.comb.reverse;
    }

    method update-memory(Int() $slot, Int() $value) {
        my @slots = self.explode($slot);
        for @slots -> $s {
            %.memory{$s} = $value;
        }
    }

    method memsum {
        return %.memory.values.sum;
    }

    method explode (Int $slot) {
        my @addr = $slot.base(2).comb.reverse;
        for @.mask.pairs -> $it {
            @addr[$it.key] //= "0";

            if $it.value eq "1" {
                @addr[$it.key] = "1";
            }
        }
        my @floating-bits = @.mask.pairs.grep({ .value eq "X" });

        my $iters = 2 ** @floating-bits.elems;
        return (^$iters).map(
            -> $n {
                my @v = @addr;
                # say "Exploting: $n";
                # say "        v: " ~ @v.gist;
                # say "     Mask: " ~ @.mask.gist;

                # An array of "0" and "1"
                my @bits = $n.base(2).Str.comb().reverse;
                my $j = 0;
                for @floating-bits -> $it {
                    @v[ $it.key ] = @bits[$j++] // "0";
                }
                # say "         : " ~ @v.gist;

                @v.reverse.join.parse-base(2);
            });
    }
}

class Machine {
    has Int $.mask0 = 0;
    has Int $.mask1 = 0;
    has Int %.memory;

    method run-instruction(Str $instruction) {
        given $instruction {
            when /^ mask \s+ \= / {
                my $mask = $instruction.comb(/<[01X]>+/).first.Str;
                self.update-mask($mask);
            }
            when /^ mem / {
                my ($slot, $value) = $instruction.comb(/<digit>+/).map: *.Int;
                self.update-memory($slot, $value);
            };
        }
    }

    method update-mask (Str $mask) {
        my $m0 = 0;
        my $m1 = 0;
        for $mask.comb.reverse.pairs -> $it {
            given $it.value {
                when "0" {
                    $m0 = $m0 +| (1 +< $it.key);
                }
                when "1" {
                    $m1 = $m1 +| (1 +< $it.key);
                }
            }
        }

        $!mask0 = $m0;
        $!mask1 = $m1;
    }

    method update-memory(Int() $slot, Int() $value) {
        %.memory{$slot} = $value +& (+^$.mask0) +| $.mask1;
    }

    method memsum {
        return %.memory.values.sum;
    }
}

sub part1 {
    my $ferry-computer-system = Machine.new;
    for "input".IO.lines -> $line {
        $ferry-computer-system.run-instruction($line);
    }
    say "mask0=" ~ $ferry-computer-system.mask0.base(2);
    say "mask1=" ~ $ferry-computer-system.mask1.base(2);
    say "memory=" ~ $ferry-computer-system.memory.gist;
    say "Part 1: " ~ $ferry-computer-system.memsum;
}

sub part2 {
    my $ferry-computer-system = MachineV2.new;

    # $ferry-computer-system.run-instruction("mask = 000000000000000000000000000000X1001X");
    # say "mask=" ~ $ferry-computer-system.mask.gist;
    # say $ferry-computer-system.explode(1).gist;
    # exit;

    for "input".IO.lines -> $line {
        $ferry-computer-system.run-instruction($line);
    }
    say "mask=" ~ $ferry-computer-system.mask.gist;
    say "memory=" ~ $ferry-computer-system.memory.gist;
    say "Part 2: " ~ $ferry-computer-system.memsum;
}
