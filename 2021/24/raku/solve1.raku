
sub MAIN(IO::Path() $input) {
    my @instructions := $input.lines.map({ [ .split(" ") ] }).Array;

    my &monad = build-model-number-automatic-detector-program(@instructions);
    say monad("51983999947999");
    say monad("11211791111365");
}

sub build-model-number-automatic-detector-program (@instructions is copy) {
    return sub (Str() $n) {
        my @digits = $n.comb(/\d/)>>.Int;
        my %vars := { :w(0), :x(0), :y(0), :z(0) };
        for @instructions.values -> ($op, $var, $v = Nil) {
            my $val;
            if $v.defined {
                $val = ($v eq "w"|"x"|"y"|"z") ?? %vars{$v} !! $v.Int;
            }

            given $op {
                when "inp" {
                    last if @digits.elems == 0;

                    # print $n,"\t",%vars.raku,"\n";

                    %vars{ $var } = @digits.shift;
                }
                when "add" {
                    %vars{ $var } += $val;
                }
                when "mul" {
                    %vars{ $var } *= $val;
                }
                when "div" {
                    %vars{ $var } = %vars{ $var } div $val;
                }
                when "mod"  {
                    %vars{ $var } %= $val;
                }
                when "eql" {
                    my $copy = %vars{ $var };
                    %vars{ $var } = (%vars{ $var } == $val) ?? 1 !! 0;
                }
            }
        }

        print $n,"\t",%vars.raku,"\n";
        # return %vars{"w", "x", "y", "z"};
        return %vars{"z"};
    };
}
