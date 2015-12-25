use v5.20;
my @aunt;
open my $fh, "<", "input";
while(<$fh>) {
    chomp;
    if (/\ASue (\d+): (.+)\z/) {
        my $id = $1;
        my %property = map { (split/: */) } split /, */, $2;
        $aunt[$id] = \%property;
    } else {
        die "WTF: $_";
    }
}
close($fh);

my %mfcsam = (
    children => 3,
    cats => 7,
    samoyeds => 2,
    pomeranians => 3,
    akitas => 0,
    vizslas => 0,
    goldfish => 5,
    trees => 3,
    cars => 2,
    perfumes => 1,
);

my $match = 0;
for my $id (1..500) {
    my $reject = 0;
    for my $p (keys %mfcsam) {
        defined(my $a = $aunt[$id]{$p}) or next;
        my $v = $mfcsam{$p};
        if ($v != $a) {
            $reject = 1;
            last;                
        }
    }
    if (!$reject) {
        $match = $id;
    }
}
say "Part 1: $match";
