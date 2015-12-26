use v5.20;

sub sum {
    my $s = 0;
    $s += $_ for @_;
    return $s;
}

my @aunt;
open my $fh, "<", "input";
my @containers = map {chomp($_); $_} <$fh>;
close($fh);

my @bitmask_containers = map { 2**$_ } 0..$#containers;

my $total_combinations = 0;

for (my $i = 0; $i < 2**(@containers); $i++) {
    my @choice;
    for my $j (0..$#bitmask_containers) {
        if ( $i & $bitmask_containers[$j] ) {
            push @choice, $containers[$j];
        }
    }
    if (sum(@choice) == 150) {
        $total_combinations++;
    }
}

say "Part 1: $total_combinations";
