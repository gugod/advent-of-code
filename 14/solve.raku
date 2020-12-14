
sub MAIN {
    part1();
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
