use v5.30;
use warnings;
use feature "signatures";

main();
exit;

sub main {
    my @risk = map { chomp; [split("")] } <>;

    # Part 2
    @risk = expand(@risk);

    my $h = 0+ @risk;
    my $w = 0+ @{ $risk[0] };

    my $weight = sub ($u, $v) {
        my ($y, $x) = split(",", $v);
        return $risk[$y][$x];
    };

    my $neighbours = sub ($v) {
        state %memo;

        $memo{$v} //= do {
            my ($y, $x) = split(",", $v);

            my @ret;
            push @ret, join(",", $y-1, $x) if $y > 0;
            push @ret, join(",", $y+1, $x) if $y < $h-1;
            push @ret, join(",", $y, $x-1) if $x > 0;
            push @ret, join(",", $y, $x+1) if $x < $h-1;

            \@ret;
        };

        return @{ $memo{$v} };
    };

    my $source = join(",", 0,0);
    my $goal   = join(",", $h-1, $w-1);

    my $dist = spfa(
        $source,
        $goal,
        $neighbours,
        $weight,
    );
    say $dist;
}

sub spfa ($source, $goal, $neighbours, $weight) {
    my %dist = ( $source => 0 );

    my (@Q, %Q);
    push @Q, $source;
    $Q{$source} = 1;

    while (@Q > 0) {
        my $u = shift @Q;
        delete %Q{$u};

        for my $v ($neighbours->($u)) {
            my $d = $dist{$u} + $weight->($u, $v);
            if ( !exists($dist{$v})  || $d < $dist{$v}) {
                $dist{$v} = $d;
                push(@Q, $v) unless $Q{$v};
            }
        }
    }

    return $dist{$goal};
}

sub expand (@risk) {
    my @risk2;

    my $h = 0+ @risk;
    my $w = 0+ @{ $risk[0] };

    for my $y (0 ... (5*$h-1)) {
        for my $x (0 ... (5*$w-1)) {
            $risk2[$y][$x] = ($risk[$y % $h][$x % $w] + int($y / $h) + int($x / $w) - 1) % 9 + 1;
        }
    }

    return @risk2;
}
