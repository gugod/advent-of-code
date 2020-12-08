sub MAIN {
    part1();
    part2();
}

class Machine {
    has @.instructions;
    has Bool $.looped = False;
    has Bool $.terminated = False;
    has Int $.accumulator = 0;

    has $!cursor = 0;
    has %!visited;

    method reset {
        $!accumulator = 0;
        $!cursor = 0;
        %!visited := {};
        $!looped = False;
        $!terminated = False;
    }

    method run {
        my $continue = True;
        while $continue {
            $continue = self.tick();
        }
    }

    method tick {
        if %!visited{ $!cursor } {
            $!looped = True;
            $!terminated = True;
            return False;
        }

        %!visited{ $!cursor } = True;

        if $!cursor > @!instructions.end {
            $!terminated = True;
            return False;
        }

        my %instruction = @!instructions[$!cursor];

        given %instruction<op> {
            when "acc" {
                $!accumulator += %instruction<arg>;
                $!cursor++;
            }
            when "jmp" {
                $!cursor += %instruction<arg>;
            }
            when "nop" {
                $!cursor++;
            }
        }
        return True;
    }

}

sub parse-instructions {
    return "input".IO.lines.map({ .split(" ") }).map(
        -> @o {
            Map.new( "op" => @o[0].Str, "arg" => @o[1].Int );
        }).Array;
}

sub part2 {
    say "# Part 2";

    my @instructions = parse-instructions;
    my $looped = True;

    # A tweak is to flip between a jmp and nop
    my @tweaks = @instructions.grep({ .<op> eq "jmp"|"nop" }, :k);

    my %tweak := %(:jmp<nop>, :nop<jmp>);
    for @tweaks -> $i {
        my %instruction = @instructions[$i];
        @instructions[$i] = Map.new( "op" => %tweak{ %instruction<op> }, "arg" => %instruction<arg> );

        my $machine = Machine.new( :instructions( @instructions ) );
        $machine.reset;
        $machine.run;

        unless $machine.looped {
            say "Terminated after tweaking instruction $i: " ~ %instruction.<op> ~ " " ~ %instruction.<arg>;
            say "Accumulator=" ~ $machine.accumulator;
            last;
        }

        @instructions[$i] = %instruction;
    }
}

sub part1 {
    say "# Part 1";
    my @instructions = parse-instructions;

    my $machine = Machine.new( :instructions( @instructions ) );
    $machine.reset;
    $machine.run;
    say "Accumulator=" ~ $machine.accumulator;
}
