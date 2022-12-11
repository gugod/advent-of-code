use v5.36;
use FindBin '$Bin';
use lib $Bin . '/../../perl5/lib';
use AoC;

sub parseMonkey ($str) {
    my @lines = split /\n/, $str;
    my ($id) = $lines[0] =~ m/([0-9]+)/g;
    my @items = $lines[1] =~ m/([0-9]+)/g;
    my @operation = $lines[2] =~ m/new = old ([\+\*]) ([0-9]+|old)$/;
    my ($test) = $lines[3] =~ m/([0-9]+)/g;
    my ($recipientOnTrue) = $lines[4] =~ m/([0-9]+)/g;
    my ($recipientOnFalse) = $lines[5] =~ m/([0-9]+)/g;
    return {
        "id" => $id,
        "items" => \@items,
        "operation" => \@operation,
        "test" => $test,
        "recipient" => {
            "true" => $recipientOnTrue,
            "false" => $recipientOnFalse,
        },
        "inspections" => 0,
    }
}

sub doBusiness ($monkeys) {
    # $monkey->{id} happens to be matching their index in the @$monkeys array.
    for my $monkey (@$monkeys) {
        next unless @{$monkey->{"items"}} > 0;

        for my $worryLevel (@{ $monkey->{items} }) {
            my $op = $monkey->{"operation"};

            my $newWorryLevel;
            if ($op->[0] eq '+') {
                $newWorryLevel = $worryLevel + $op->[1];
            }
            else {
                if ($op->[1] eq 'old') {
                    $newWorryLevel = $worryLevel ** 2;
                }
                else {
                    $newWorryLevel = $worryLevel * $op->[1];
                }
            }

            $newWorryLevel = int $newWorryLevel / 3;

            my $recipientMonkeyId = $monkey->{"recipient"}{
                ($newWorryLevel % $monkey->{"test"} == 0) ? "true" : "false"
            };

            push @{ $monkeys->[ $recipientMonkeyId ]{"items"} }, $newWorryLevel;
            $monkey->{"inspections"}++;
        }

        $monkey->{"items"} = [];
    }
    return;
}

## main
my $in = slurp(shift // "input");
my @monkeys = map { parseMonkey($_) } split /\n\n/, $in;

my $rounds = 0;
while ($rounds++ < 20) {
    doBusiness(\@monkeys);
}

my @scores = sort { $b <=> $a } map { $_->{"inspections"} } @monkeys;
say $scores[0] * $scores[1];
