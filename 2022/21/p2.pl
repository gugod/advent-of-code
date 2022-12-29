use v5.36;
use Data::Dumper qw(Dumper);
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

main(@ARGV);
exit;

sub main ( $input = "input" ) {
    my @lines = map {[comb qr/ [a-z]+ | [\+\-\*\/] | [0-9]+ /x, $_]} slurp($input);

    my %computed = map { ($_->[0] => $_->[1]) } grep { !defined($_->[2]) } @lines;
    delete $computed{"humn"};
    $computed{"ZERO"} = 0;

    my %lhsFormulas = map {
        my ($fn1, $fn2, $op, $fn3) = @$_;
        ( $fn1 => [$fn2, $op, $fn3] );
    } grep {
        defined $_->[2]
    } @lines;
    delete $lhsFormulas{"root"};
    delete $lhsFormulas{"humn"};

    my %rhsFormulas = map {
        my ($fn1, $fn2, $op, $fn3) = @$_;

        ($op eq any('+', '*')) ? (
            $fn2 => [$fn1, inverseOf($op), $fn3],
            $fn3 => [$fn1, inverseOf($op), $fn2],
        ) : ($op eq '-') ? (
            $fn2 => [$fn1, '+', $fn3],
            $fn3 => [$fn2, '-', $fn1],
        ) : (
            $fn2 => [$fn1, '*', $fn3],
            $fn3 => [$fn2, '/', $fn1],
        );
    } grep {
        defined $_->[2]
    } @lines;

    for ( first { $_->[0] eq "root" } @lines ) {
        my ($fn1, $fn2, $op, $fn3) = @$_;
        $rhsFormulas{$fn2} = ['ZERO', '+', $fn3];
        $rhsFormulas{$fn3} = ['ZERO', '+', $fn2];
    }

    while (! $computed{"humn"}) {
        for my $formulas (\%lhsFormulas, \%rhsFormulas) {
            for my $q (keys %$formulas) {
                next if defined $computed{$q};
                my ($fn2, $op, $fn3) = @{ $formulas->{$q} };
                if ( defined($computed{$fn2}) && defined($computed{$fn3}) ) {
                    $computed{$q} = compute($op, $computed{$fn2}, $computed{$fn3});
                }
            }
        }
    }

    say $computed{"humn"};
}

sub compute ($op, $n1, $n2) {
    return $n1 + $n2 if $op eq '+';
    return $n1 - $n2 if $op eq '-';
    return $n1 * $n2 if $op eq '*';
    return $n1 / $n2 if $op eq '/';
}

sub inverseOf ($op) {
    state $inv = {
        '+' => '-',
        '-' => '+',
        '*' => '/',
        '/' => '*',
    };
    return $inv->{$op};
}
