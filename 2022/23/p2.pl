use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input" ) {
    my $elvesWhereAbout = parseInput($input);

    my $round = 0;
    my $i = 1;
    while ($round == 0) {
        my $plan = survey($elvesWhereAbout, $i);

        if (first { !! $_ } @$plan) {
            commit($plan, $elvesWhereAbout);
        } else {
            $round = $i;
            last;
        }

        $i++;
    }
    say $round;
}
main(@ARGV);
exit();

sub northOf ($p) { { x => $p->{x},     y => $p->{y} - 1 } }
sub southOf ($p) { { x => $p->{x},     y => $p->{y} + 1 } }
sub westOf ($p)  { { x => $p->{x} - 1, y => $p->{y}     } }
sub eastOf ($p)  { { x => $p->{x} + 1, y => $p->{y}     } }
sub nwOf ($p)    { { x => $p->{x} - 1, y => $p->{y} - 1 } }
sub neOf ($p)    { { x => $p->{x} + 1, y => $p->{y} - 1 } }
sub swOf ($p)    { { x => $p->{x} - 1, y => $p->{y} + 1 } }
sub seOf ($p)    { { x => $p->{x} + 1, y => $p->{y} + 1 } }

sub k ($p) { join(" ", $p->{y}, $p->{x}) }

sub survey ($elvesWhereAbout, $round) {
    my sub noElfAt ($p) { not $elvesWhereAbout->{whereabout}{ k($p) } }
    my sub okN ($p) { noElfAt( northOf($p) ) }
    my sub okS ($p) { noElfAt( southOf($p) ) }
    my sub okE ($p) { noElfAt( eastOf($p) ) }
    my sub okW ($p) { noElfAt( westOf($p) ) }
    my sub okNE ($p) { noElfAt( neOf($p) ) }
    my sub okNW ($p) { noElfAt( nwOf($p) ) }
    my sub okSE ($p) { noElfAt( seOf($p) ) }
    my sub okSW ($p) { noElfAt( swOf($p) ) }
    my sub goNorth ($p) { okN($p) && okNE($p) && okNW($p) && northOf($p) }
    my sub goSouth ($p) { okS($p) && okSE($p) && okSW($p) && southOf($p) }
    my sub goWest ($p)  { okW($p) && okNW($p) && okSW($p) && westOf($p) }
    my sub goEast ($p)  { okE($p) && okNE($p) && okSE($p) && eastOf($p) }
    my sub anyElvesAround ($p) {
        reduce { $a || $b } map { !noElfAt($_->($p)) } (\&northOf, \&southOf, \&eastOf, \&westOf, \&nwOf, \&neOf, \&swOf, \&seOf);
    }

    my sub goNSWE ($p) {
        my @go = (\&goNorth, \&goSouth, \&goWest, \&goEast);
        my $r = false;
        for my $i ( map { ($_ + $round - 1) % 4 } (0..3) ) {
            $r ||= $go[$i]->($p);
            last if $r;
        }
        return $r;
    }

    my $plan = [
        map {
            anyElvesAround($_) && goNSWE($_)
        } @{ $elvesWhereAbout->{elves} }
    ];

    my %seen;
    for my $p ( @$plan ) {
        next unless $p;
        $seen{ k($p) }++
    }

    for my $i ( arrayindices $plan ) {
        my $p = $plan->[$i]
            or next;
        $plan->[$i] = undef if $seen{ k($p) } > 1;
    }

    return $plan;
}

sub commit ($plan, $elvesWhereAbout) {
    my $elves = $elvesWhereAbout->{elves};
    for my $i ( arrayindices $plan ) {
        next unless $plan->[$i];

        delete $elvesWhereAbout->{whereabout}{ k( $elves->[$i] ) };
        $elvesWhereAbout->{whereabout}{ k($plan->[$i]) } = true;

        $elves->[$i] = $plan->[$i];
    }
}

sub coverage ($elvesWhereAbout) {
    my $elves = $elvesWhereAbout->{elves};
    my ($ymin, $ymax) = minmax map { $_->{y} } @$elves;
    my ($xmin, $xmax) = minmax map { $_->{x} } @$elves;
    ($xmax - $xmin + 1) * ($ymax - $ymin + 1) - @$elves
}

sub visual ($elvesWhereAbout) {
    my $elves = $elvesWhereAbout->{elves};
    my ($ymin, $ymax) = minmax map { $_->{y} } @$elves;
    my ($xmin, $xmax) = minmax map { $_->{x} } @$elves;

    my sub elfAt ($y, $x) {
        $elvesWhereAbout->{whereabout}{"$y $x"}
    }

    my $canvas = "";
    for my $y ( $ymin ... $ymax ) {
        for my $x ( $xmin ... $xmax ) {
            $canvas .= elfAt($y, $x) ? "#" : ".";
        }
        $canvas .= "\n";
    }
    $canvas;
}

sub parseInput ($input) {
    my (@elves, %whereabout);

    my $j = 0;
    for my $line ( slurp($input) ) {
        for my $i ( 0..length($line) ) {
            if (substr($line, $i, 1) eq '#') {
                my $p = { y => $j, x => $i };
                push @elves, $p;
                $whereabout{k($p)} = true;
            }
        }
        $j++;
    }

    return {
        elves => \@elves,
        whereabout => \%whereabout,
    }
}
