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

sub solvePart2 ($caloriesPerElf) {
    my @sorted = sort { $b <=> $a } map { sum(@$_) } @$caloriesPerElf;
    my @topThree = @sorted[0, 1, 2];
    say sum(@topThree);
}

die "I need input" unless $ARGV[0];

open my $fh, '<', $ARGV[0];
my $calories = readElfCalories($fh);

# solvePart1($calories);
solvePart2($calories);
