use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input" ) {
    my $G = buildValveGraph( $input );

    my $i = 0;
    my $max = 0;

    my @openableValves =  grep { $G->{"rate"}{$_} > 0 } @{$G->{"nodes"}};
    my $opened = { map { $_ => 0 } @openableValves };
    my @Q = (["AA", 30, 0, $opened, 0+@openableValves]);

    my %visited;
    while (@Q) {
        my $now = pop @Q;
        my ($valve, $minutesLeft, $eventualReleases, $opened, $openableValves) = @$now;

        my $k = "$valve $minutesLeft $eventualReleases $openableValves";
        next if $visited{$k};
        $visited{$k} = true;

        if ($eventualReleases > $max) {
            $max = $eventualReleases;
            say gist $max, $minutesLeft, [ map { @$_} rev_nsort_by { $_->[1] } grep { $_->[1] > 0 } pairs %$opened];
        }

        if ($minutesLeft <= 0) {
            next;
        }

        if ($openableValves == 0) {
            push @Q, [$valve, 0, $eventualReleases, $opened, $openableValves];
            next;
        }

        my $rate = $G->{"rate"}{$valve};

        if ($rate > 0 && $opened->{$valve} == 0) {
            push @Q, [
                $valve,
                $minutesLeft - 1,
                $eventualReleases + $rate * ($minutesLeft - 1),
                { %$opened, $valve => $minutesLeft },
                $openableValves - 1
            ];
        }
        my @next = nextValvesToVisit( $G, $valve, $minutesLeft, $opened );
        # if (@next) {
        #     say gist $valve, [map { $_ => $G->{"rate"}{$_} } @next], $opened;
        # }
        for my $v (@next) {
            my $d = shortestDistance( $G, $valve, $v );
            if ($minutesLeft >= $d) {
                push @Q, [
                    $v,
                    $minutesLeft - $d,
                    $eventualReleases,
                    $opened,
                    $openableValves
                ];
            }
        }
    }

    say $max;
}

main(@ARGV);
exit();

sub buildValveGraph ( $input ) {
    my $G = {
        "nodes" => [],
        "rate" => {},
        "connection" => {},
    };

    for my $row (map { [ comb qr/(?:[A-Z]{2}|[0-9]+)/, $_ ] } slurp($input)) {
        my ($src, $rate, @dest) = @$row;
        push @{ $G->{"nodes"} }, $src;
        $G->{"rate"}{$src} = $rate;
        $G->{"connection"}{$src} = \@dest;
    }

    $G->{"allPairShortestPath"} = buildAllPairShortestPath(
        $G->{"nodes"},
        sub ($v) {
            $G->{"connection"}{$v}
        },
        sub ($u,$v) { 1 }
    );

    return $G;
}

sub buildAllPairShortestPath (
    $vertices = [],
    $neighbours = sub ($v) { ...; [] },
    $weight = sub($u,$v) { ... },
) {
    my $D = {};

    for my $i (@$vertices) {
        for my $j (@$vertices) {
            $D->{$i}{$j} = VeryLargeNum;
        }
    }

    for my $i (@$vertices) {
        $D->{$i}{$i} = 0;
        for my $j ( slip $neighbours->($i) ) {
            $D->{$i}{$j} = $weight->($i, $j);
        }
    }

    for my $k (@$vertices) {
        for my $i (@$vertices) {
            for my $j (@$vertices) {
                $D->{$i}{$j} = min $D->{$i}{$j}, $D->{$i}{$k} + $D->{$k}{$j};
            }
        }
    }

    return $D;
}

sub shortestDistance ( $G, $v1, $v2 ) {
    $G->{"allPairShortestPath"}{$v1}{$v2}
}

sub nextValvesToVisit ( $G, $currentValve, $minutesLeft, $opened ) {
    return map {
        $_->[0]
    } rev_nsort_by {
        $_->[2]
    } grep {
        $_->[2] > 0
    } map {[
        @$_,
        $G->{"rate"}{$_->[0]} * ($minutesLeft - shortestDistance($G, $currentValve, $_->[0]) - 1)
    ]} grep {
        ($_->[0] ne $currentValve)
            && ($G->{"rate"}{$_->[0]} > 0)
            && ($opened->{ $_->[0] } == 0)
    } pairs %{ $G->{"allPairShortestPath"}{$currentValve} };
}
