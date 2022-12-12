
sub MAIN( $input = "input" ) {
    my @monkeys = $input.IO.slurp.split("\n\n").map: &parse-monkey;

    for ^10000 {
        do-business(@monkeys);
    }

    say [*] nmax2 map { .<inspections> }, @monkeys;
}

sub parse-monkey (Str $s) {
    my @line = $s.split("\n");
    my %monkey = (
        "id" => @line[0].comb(/\d+/)[0],
        "items" => @line[1].comb(/\d+/).Array,
        "operation" => @line[2].comb(/(old|<[\*\+]>|\d+)/).Array,
        "test" => @line[3].comb(/\d+/)[0],
        "recipient" => {
            "true" => @line[4].comb(/\d+/)[0],
            "false" => @line[5].comb(/\d+/)[0],
        },
        "inspections" => 0,
    );

    return %monkey;
}

sub do-business (@monkeys) {
    state $lcm = [lcm] @monkeys.map: *.<test>;

    for @monkeys -> %monkey {
        for %monkey<items>[*] -> $worryLevel {
            my $op = %monkey<operation>;
            my $op2 = $op[2] eq 'old' ?? $worryLevel !! $op[2].Int;
            my $newWorryLevel = do {
                given ($op[1]) {
                    when '+' { $worryLevel + $op2 }
                    when '*' { $worryLevel * $op2 }
                }
            };

            $newWorryLevel %= $lcm;

            my $recipient = %monkey<recipient>{
                $newWorryLevel %% %monkey<test> ?? "true" !! "false"
            };

            @monkeys[$recipient]<items>.push: $newWorryLevel;

            %monkey<inspections>++;
        }
        %monkey<items> = [];
    }
}

sub nmax2 ( @nums ) {
    my ($max1, $max2) = @nums[0,1];

    if $max1 < $max2 {
        ($max1, $max2) = ($max2, $max1);
    }

    for @nums.kv -> $i, $e {
        if $e > $max1 {
            ($max2, $max1) = ($max1, $e);
        }
        elsif $e > $max2 {
            $max2 = $e;
        }
    }

    return ($max1, $max2);
}
