use v5.20;
my %deer;
open my $fh, "<", "input";
while(<$fh>) {
    chomp;
    if (/\A(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./) {
        $deer{$1} = [$2, $3, $4];
    } else {
        die "WTF: $_";
    }
}
close($fh);

sub compute_winner {
    my ($t) = @_;
    my $max = -1;
    my $winner;
    for my $deer_name (keys %deer) {
        my ($speed, $t_sprint, $t_rest) = @{$deer{$deer_name}};
        my $t_cycle = $t_sprint + $t_rest;
        my $complete_cycles = int( $t / $t_cycle );
        my $t_remain = $t % $t_cycle;
        my $travel_distance = $complete_cycles * ( $speed * $t_sprint) + $speed*( ($t_remain < $t_sprint) ? $t_remain : $t_sprint );
        if ($max < $travel_distance) {
            $winner = $deer_name;
            $max = $travel_distance;
        }
    }
    return ($winner, $max);
}

my ($winner, $travel_distance) = compute_winner(2503);
say "Part 1: Winner: $winner, Travel: $travel_distance";

my %points;
for (1..2503) {
    my ($winner, $travel_distance) = compute_winner($_);
    $points{$winner}++;
}
my $winner_points = -1;
for my $deer_name (keys %points) {
    my $p = $points{$deer_name};
    if ($winner_points < $p) {
        $winner_points = $p;
        $winner = $deer_name;
    }
}
say "Part 2: Winner $winner, Points: $winner_points";
