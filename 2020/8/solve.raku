
class Machine {
    has @.instructions;
    has Bool $.looped = False;
    has Bool $.terminated = False;

    has $!accumulator = 0;
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
            say "[loop] cursor = $!cursor, accumulator = $!accumulator";
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

part1();
# part2();

sub parse-instructions {
    return "input".IO.lines.map({ .split(" ") }).map(
        -> @o {
            Map.new( "op" => @o[0].Str, "arg" => @o[1].Int );
        }).Array;
}

sub part2 {

}

sub part1 {
    my @instructions = parse-instructions;

    my $machine = Machine.new( :instructions( @instructions ) );
    $machine.reset;
    $machine.run;
}
