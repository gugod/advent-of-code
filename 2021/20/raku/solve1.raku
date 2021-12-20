
sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    my @algo[512] = @lines[0].comb;
    my @img0 = @lines[2..*].>>.comb;

    my %canvas0 = cartesian-from-input(@img0);
    vis(%canvas0);

    my %c = %canvas0;
    say "# Begin \t" ~ count-of-lit-pixels(%c);
    for 1..50 -> $i {
        # my $void = '.';
        my $void = $i %% 2 ?? '#' !! '.';
        add-padding(%c, $void);
        %c = enhance(%c, @algo, $void);
        # vis(%c);
        say "# Generation $i" ~ "\t" ~ count-of-lit-pixels(%c);;

    }
}

sub enhance (%c, @algo, $void) {
    my $xrange = %c.keys>>.Int.minmax;
    my $yrange = %c.values>>.keys>>.Int.minmax;

    my %c2;
    for $yrange.values X $xrange.values -> ($y, $x) {
        my $n = (
            %c{$y-1}{$x-1},
            %c{$y-1}{$x},
            %c{$y-1}{$x+1},
            %c{$y}{$x-1},
            %c{$y}{$x},
            %c{$y}{$x+1},
            %c{$y+1}{$x-1},
            %c{$y+1}{$x},
            %c{$y+1}{$x+1},
        ).map({ $_ // $void })
         .map({ $_ eq "#" ?? "1" !! "0" }).join.parse-base(2);

        %c2{$y}{$x} = @algo[$n];
    }
    return %c2;
}

sub count-of-lit-pixels (%c) {
    my $c;
    %c.deepmap({ $c++ if $_ eq '#' });
    return $c;
}

sub vis (%c) {
    my $xrange = %c.keys>>.Int.minmax;
    my $yrange = %c.values>>.keys>>.Int.minmax;

    my $out = "";
    my $pixels = 0;
    for $yrange.values -> $y {
        my @v := $xrange.values;
        $out ~= @v.map(-> $x { %c{$y}{$x} // '.' }).join;
        $out ~= "\n";
    }
    say $out;
    # sleep 1;
    # spurt("/tmp/vis" ~ time ~ ".txt", $out);
}

sub add-padding (%c, $void) {
    my $xrange = %c.keys>>.Int.minmax;
    my $yrange = %c.values>>.keys>>.Int.minmax;

    for ($yrange.min-1, $yrange.max+1) X ($xrange.min-1 .. $xrange.max+1) -> ($y, $x) {
        %c{$y}{$x} //= $void;
    }
    for ($yrange.min-1.. $yrange.max+1) X ($xrange.min-1, $xrange.max+1) -> ($y, $x) {
        %c{$y}{$x} //= $void;
    }
    return %c;
}

sub cartesian-from-input (@img) {
    my $h = @img.elems;
    my $w = @img[0].elems;

    my %canvas;
    for ^$h -> $y {
        for ^$w -> $x {
            %canvas{$y}{$x} = @img[$y][$x];
        }
    }
    return %canvas;
}
