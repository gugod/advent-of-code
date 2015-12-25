use v5.20;

sub compute_property {
    my ($ingredient, $n) = @_;
    my @property = (0,0,0,0,0);
    for my $j (0..4) {
        for my $i (0..$#$ingredient) {
            $property[$j] += $ingredient->[$i][$j+1] * $n->[$i];
        }
    }
    return @property;
}

my @ingredient;
open my $fh, "<", "input";
while(<$fh>) {
    chomp;
    if (/\A(\w+): capacity ([\-0-9]+), durability ([\-0-9]+), flavor ([\-0-9]+), texture ([\-0-9]+), calories ([\-0-9]+)/) {
        push @ingredient, [$1, $2, $3, $4, $5, $6];
    } else {
        die "WTF: $_";
    }
}
close($fh);

my $max = 0;
for my $n1 (1..97) {
    for my $n2 (1..(98-$n1)) {
        for my $n3 (1..(98-$n1-$n2)) {
            my $n4 = 100 - $n1 - $n2 - $n3;
            my @p = map { $_ < 0 ? 0 : $_ } compute_property(\@ingredient, [$n1, $n2, $n3, $n4]);
            my $score = $p[0] * $p[1] * $p[2] * $p[3];
            if ($score > $max) {
                $max = $score;
            }
        }
    }
}
say "Part 1: $max";
