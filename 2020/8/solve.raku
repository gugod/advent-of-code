
class Machine {
    has $.input;

    has @!instructions;
    has $!accumulator = 0;
    has $!cursor = 0;
    has %!visited;

    method run {
        @!instructions = "input".IO.lines.map({ .split(" ") }).map(
        -> @o {
            Map.new( "op" => @o[0].Str, "arg" => @o[1].Int );
        });

        my $continue = True;
        while $continue {
            $continue = self.tick();
        }
    }

    method tick {
        if %!visited{ $!cursor } {
            say "[loop] cursor = $!cursor, accumulator = $!accumulator";
            return False;
        }

        %!visited{ $!cursor } = True;

        if $!cursor > @!instructions.end {
            say "Errr...";
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

        say "cursor = $!cursor, accumulator = $!accumulator";
        return True;
    }

}

part1();
# part2();

sub part2 {
    ...
}

sub part1 {
    Machine.new( :input("input") ).run;
}
