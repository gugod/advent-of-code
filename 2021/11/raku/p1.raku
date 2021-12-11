sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    my $height = @lines.elems;
    my $width  = @lines[0].chars;
    my @energy = @lines.join.comb.map(*.Int);

    my $total_flashes = 0;

    for ^100 -> $step {
        my $flashes = one-step-for-octupus($width, $height, @energy);
        $total_flashes += $flashes;
    }
    letssee("Last step -- $total_flashes flashes", $width, $height, @energy);

    say $total_flashes;
}

sub one-step-for-octupus (Int $w is readonly, Int $h is readonly, @energy) {
    @energy <<+=>> 1;
    my %flashed = ();
    loop {
        my $i = @energy.keys.first: { !%flashed{$_} && @energy[$_] > 9 };
        last unless defined($i);

        %flashed{$i} = True;
        @energy[ neighbours($i, $w, $h) ] <<+=>> 1;
    }

    @energy[ %flashed.keys ] = 0 xx *;

    return %flashed.keys.elems;
}

sub neighbours (Int $i is readonly, Int $width is readonly, Int $height is readonly) {
    my $size = $width * $height;
    return gather {
        unless $i %% $width {
            take($i-1);
            take($i-1-$width);
            take($i-1+$width);
        }
        unless ($i+1) %% $width {
            take($i+1);
            take($i+1-$width);
            take($i+1+$width);
        }
        take($i-$width);
        take($i+$width);
    }.grep(^$size);
}

sub letssee ($title is readonly, $w is readonly, $h is readonly, @energy is readonly) {
    say "# $title";
    for ^$h -> $i {
        say @energy[($i*$h)..($i*$h+$w-1)].join;
    }
    say "";
}
