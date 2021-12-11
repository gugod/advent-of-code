sub MAIN(IO::Path() $input) {
    my @lines = $input.lines;
    my $height = @lines.elems;
    my $width  = @lines[0].chars;
    my @energy = @lines.join.comb.map(*.Int);

    my $total_flashes = 0;

    my $step = 1;
    loop {
        my $flashes = one-step-for-octupus($width, $height, @energy);
        last if $flashes == @energy.elems;
        $step++;
    }
    letssee("Last step -- $total_flashes flashes", $width, $height, @energy);

    say $step;
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

sub neighbours (Int $i is readonly, Int $w is readonly, Int $h is readonly) {
    return gather {
        take slip ($w, -$w) >>+>> $i;

        unless $i %% $w {
            take slip ($w, 0, -$w) >>+>> ($i-1);
        }
        unless ($i+1) %% $w {
            take slip ($w, 0, -$w) >>+>> ($i+1);
        }
    }.grep(^($w * $h));
}

sub letssee ($title is readonly, $w is readonly, $h is readonly, @energy is readonly) {
    say "# $title";
    for ^$h -> $i {
        say @energy[($i*$h)..($i*$h+$w-1)].join;
    }
    say "";
}
