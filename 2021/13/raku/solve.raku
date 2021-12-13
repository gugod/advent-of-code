
sub MAIN(IO::Path() $input) {
    my @dots;
    my @foldings;
    for $input.lines -> $line {
        if ($line ~~ /^fold/) {
            my ($axis, $num) = $line.comb(/<[xy]>|\d+/);
            @foldings.push($[$axis, $num.Int]);
        }
        elsif ($line ~~ /^\d/) {
            my @xy = $line.comb(/\d+/)>>.Int;
            @dots.push(@xy);
        }
    }

    # vis(@dots);
    say "Begin with " ~ @dots.elems ~ " dots";
    for @foldings -> [$axis, $foldline] {
        my %parts;
        given $axis {
            when "x" {
                %parts = @dots.categorize: { .[0] < $foldline ?? "p1" !! "p2" }
                %parts<p2>.=map({ [ (2*$foldline - .[0] ), .[1] ] }).=Array;
            }
            when "y" {
                %parts = @dots.categorize: { .[1] < $foldline ?? "p1" !! "p2" }
                %parts<p2>.=map({ [ .[0], (2*$foldline - .[1])] }).=Array;
            }
        }

        @dots = (%parts<p1>:!exists) ?? %parts<p2>.values
                 !! (%parts<p2>:!exists) ??  %parts<p1>.values
                 !! (%parts<p1> ∪ %parts<p2>.grep({ $_ eqv none(%parts<p1>)})).keys;

        # vis(@dots);
        say "fold $axis $foldline --> " ~ @dots.elems ~ " dots remain";
    }

    vis(@dots);
}

sub vis(@dots) {
    # say "# Vis -- " ~ @dots.elems ~ " dots";
    my $xpos = 1 + @dots.map({ .[0] }).max;
    my $ypos = 1 + @dots.map({ .[1] }).max;
    for ^$ypos -> $y {
        my @line = " " xx $xpos;
        for @dots.grep({ .[1] == $y }).map({ .[0] }) {
            @line[  $_ ] = ['█'].pick;
        }

        say @line.join;
    }
}
