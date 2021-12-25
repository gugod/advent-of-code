
sub MAIN(IO::Path() $input) {
    my @instructions := $input.lines.map({ [ .split(" ") ] }).Array;
    part1(@instructions);
}

sub part1 (@instructions) {
    my &monad = build-model-number-automatic-detector-program(@instructions);
    my $model-nums := (99999999999999, * - 1 ... 11111111111111).grep(! *.Str.match(/0/));
    # my $model-nums := (11111111111111, * + 1 ... 99999999999999).grep(! *.Str.match(/0/));
    say $model-nums.hyper.first({ monad($^n) });
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
                    %vars{ $var } = (%vars{ $var } == $val) ?? 1 !! 0;
                }
            }
        }

        %vars<z>.Int == 0;
    };
}
