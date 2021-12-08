#!/usr/bin/env raku

sub MAIN (IO::Path() $input) {
    my @digits = $input.comb(/\d/).Array;
    part2(@digits);
    # part1(@digits);
}

sub part2(@digits) {
    my $gap = floor( @digits.elems / 2 );
    @digits.keys.grep(-> $i {
        @digits[$i] eq @digits[ ($i + $gap) % @digits.elems ]
    }).map({ @digits[$_] }).sum.say;
}

sub part1(@digits is copy) {
    @digits.push(@digits[0]);
    @digits.rotor(2 => -1).grep({ .[0] eq .[1] }).map(*.[0]).sum.say;
}
