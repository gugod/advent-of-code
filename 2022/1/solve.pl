use v5.36;
use Data::Dumper;
use List::Util qw(max sum);

sub readElfCalories ($fh) {
    local $/ = "\n\n";
    my @calories = map { [split /\n/] } <$fh>;
    return \@calories;
}

sub solvePart1 ($caloriesPerElf) {
    my $maxCalorie = max map { sum(@$_) } @$caloriesPerElf;
    say $maxCalorie;
}

sub quickSelectTopK( $nums, $k ) {
    my $start = 0;
    my $end = $#$nums;

    while ($end > $start) {
        my $pivotPos = $start + int rand($end - $start + 1);
        my $pivot = $nums->[$pivotPos];

        ($nums->[ $pivotPos ], $nums->[ $end ]) = ($nums->[ $end ], $nums->[ $pivotPos ]);
        $pivotPos = $end;

        my $i = $start;
        for my $j ( $start .. $end - 1 ) {
            if ($nums->[$j] > $pivot) {
                ($nums->[$i], $nums->[$j]) = ($nums->[$j], $nums->[$i]);
                $i++;
            }
        }

        ($nums->[$i], $nums->[$pivotPos]) = ($nums->[$pivotPos], $nums->[$i]);
        $pivotPos = $i;

        if ($pivotPos < $k) {
            $start = $pivotPos;
        } else {
            $end = $pivotPos - 1;
        }
    }

    return @$nums[0..$k-1];
}

sub solvePart2 ($caloriesPerElf) {
    my @calories = map { sum(@$_) } @$caloriesPerElf;
    my @top3 = quickSelectTopK( \@calories, 3 );
    say sum(@top3);
}

die "I need input" unless $ARGV[0];

open my $fh, '<', $ARGV[0];
my $calories = readElfCalories($fh);

# solvePart1($calories);
solvePart2($calories);
