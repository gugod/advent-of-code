use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub main ( $input = "input" ) {
    my ($map, $instruction) = parseInput($input);

    # cursor = {y,x,facing};
    my $cursor = start($map);

    for my $x ( @$instruction ) {
        if ($x =~ /[LR]/) {
            $cursor = turn($cursor, $x);
        } elsif ($x =~ /[0-9]+/) {
            for (1..$x) {
                if (my $next = forward($cursor, $map)) {
                    $cursor = $next;
                } else {
                    last;
                }
            }
        }
    }

    say 1000 * (1 + $cursor->{y}) + 4 * (1 + $cursor->{x}) + $cursor->{facing};
}

main(@ARGV);
exit();

sub parseInput ($input) {
    my ($rawMap, $rawInstruction) = split /\n\n/, scalar slurp($input);
    my @map = map { [ split // ] } split /\n/, $rawMap;

    my $maxWidth = max( map { elems $_ } @map );
    for my $row (@map) {
        next unless elems($row) < $maxWidth;
        @{$row}[ elems($row) ... $maxWidth-1 ] = (' ') x ($maxWidth - elems($row));
    }

    my @instruction = comb qr/[0-9]+|L|R/, $rawInstruction;

    return (\@map, \@instruction);
}

sub mapHeight ($map) { scalar @$map }
sub mapWidth ($map) { scalar @{$map->[0]} }
sub rowIndicesOf ($map) { 0...$#$map }
sub columnIndicesOf ($map) { 0...$#{$map->[0]} }

sub start ($map) {
    my $j = 0;
    my $row = $map->[$j];
    my $i = first { $row->[$_] eq '.' } columnIndicesOf($map);
    # facing = 0:> 1:v 2:< 3:^
    return { y => $j, x => $i, facing => 0 };
}

sub turn ($cursor, $dir) {
    return { %$cursor, facing => (($cursor->{facing} + ($dir eq 'R' ? 1 : -1)) % 4) };
}

sub tileOf($map, $cursor) {
    $map->[ $cursor->{y} ][ $cursor->{x} ]
}

sub oob ($map, $cursor) {
    not ( ( 0 <= $cursor->{y} < mapHeight($map) ) && ( 0 <= $cursor->{x} < mapWidth($map) ) )
}

sub warp ($cursor, $map) {
    my $axis = ($cursor->{facing} == any(0,2)) ? "x" : "y";
    my $sign = ($cursor->{facing} == any(0,1)) ? 1 : -1;

    my $bound = $axis eq 'x' ? mapWidth($map) : mapHeight($map);
    my $next = { %$cursor };

    for my $inc (1..$bound) {
        my $p = $cursor->{$axis} - $sign * $inc;
        my $candidate = { %$cursor, $axis => $p };
        last if oob($map, $candidate) || tileOf($map, $candidate) eq ' ';
        $next = $candidate;
    }

    return $next;
}

sub forward ($cursor, $map) {
    my $next = { %$cursor };

    my $axis = ($cursor->{facing} == any(0,2)) ? "x" : "y";
    my $inc = ($cursor->{facing} == any(0,1)) ? 1 : -1;

    $next->{$axis} += $inc;

    $next = warp($next, $map) if oob($map, $next) || (tileOf($map, $next) eq ' ');

    if (tileOf($map, $next) eq '#') {
        return undef;
    }

    return $next;
}

sub visual($map, $trace) {
    my @map2 = map { [@$_] } @$map;
    my $shape = ['>', 'v', '<', '^'];

    for my $cursor ( @$trace ) {
        $map2[ $cursor->{y} ][ $cursor->{x} ] = $shape->[ $cursor->{facing} ];
    }

    return join "\n", map { join "", @$_ } @map2;
}
