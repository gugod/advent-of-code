use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

my @sides = ([0,0,1],[0,1,0],[1,0,0],[0,0,-1],[0,-1,0],[-1,0,0]);

sub MAIN ( $input = "input" ) {
    my @cubies = map { ArrayRef comb(qr/[0-9]+/, $_) } slurp($input);

    my %cubeAt = map { ("@$_", 1) } @cubies;

    my $inPocket = buildAirPocket( \@cubies, \%cubeAt );

    my $count = 0;
    for my $c (@cubies) {
        for my $side (sixSidesOf($c)) {
            if (! $cubeAt{"@$side"} && ! $inPocket->{"@$side"}) {
                $count += 1;
            }
        }
    }
    say $count;

}

MAIN( @ARGV );
exit();

sub vecplus ($x, $y) {
    [ map { $x->[$_] + $y->[$_] } (0 .. $#$x) ]
}

sub vecmultiply ($n, $v) {
    [ map { $n * $v->[$_] } (0 .. $#$v) ]
}

sub sixSidesOf ($c) {
    map { vecplus($c,$_) } @sides
}

sub buildAirPocket ( $cubies, $cubeAt ) {
    my %inPocket;

    my @axisMinMax = map {
        my $axis = $_;
        ArrayRef minmax( map { $_->[$axis] } @$cubies )
    } (0,1,2);

    my %outside;
    my %airAt;
    my @airCubes;
    for my $c (@$cubies) {
        push @airCubes, grep { ! $cubeAt->{"@$_"} } sixSidesOf($c);
    }
    for my $c (@airCubes) {
        $airAt{"@$c"} = 1;
    }

    my %maybeInPocket;
    my $unit = [ [1,0,0], [0,1,0], [0,0,1] ];
    for my $c (@airCubes) {
        my $inside = 0;
        for my $axis (0,1,2) {
            for my $dir (-1, 1) {
                my $n = 1;
                while (true) {
                    my $x = vecplus( $c, vecmultiply($dir * $n, $unit->[$axis]) );
                    last unless $axisMinMax[$axis][0] <= $x->[$axis] <= $axisMinMax[$axis][1];
                    if ($cubeAt->{"@$x"}) {
                        $inside++;
                        last;
                    }
                    $n++;
                }
            }
        }
        if ($inside < 6) {
            $outside{"@$c"} = 1;
        }
        else {
            $maybeInPocket{"@$c"} = $c;
        }
    }

    foreach my $c (values %maybeInPocket) {
        next if $outside{"@$c"};

        my %checked;

        my %inStash = ( "@$c" => 1 );
        my @stash = ($c);

        my $i = 0;
        while ($i < @stash) {
            my $c = $stash[$i++];
            next if $outside{"@$c"} || $checked{"@$c"};
            for my $d (sixSidesOf($c)) {
                next if $cubeAt->{"@$d"};
                if ($outside{"@$d"}) {
                    for (@stash) {
                        $outside{"@$_"} = 1;
                    }
                    next;
                } else {
                    unless ($inStash{"@$d"}) {
                        push @stash, $d;
                        $inStash{"@$d"} = 1;
                    }
                }
            }

            $checked{"@$c"} = 1;
            # say gist "wait... ", 0+@stash;
        }
    }

    foreach my $k (keys %maybeInPocket) {
        next if $outside{$k};
        $inPocket{$k} = 1;
    }

    return \%inPocket;
}
