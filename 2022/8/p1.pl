use v5.36;
use File::Slurp qw(slurp);
my $in = slurp("input");

my @treescape = map { [ split "",  $_ ] } split "\n", $in;
my %seen;

my $rowEnd = $#treescape;
my $colEnd = $#{$treescape[0]};

for my $row (0..$rowEnd) {
    # scan ->
    my $height = -1;
    for my $col (0..$colEnd) {
        if ($treescape[$row][$col] > $height) {
            $seen{"$row $col"}++;
            $height = $treescape[$row][$col];
        }
    }

    # scan <-
    $height = -1;
    for my $col (reverse 0..$colEnd) {
        if ($treescape[$row][$col] > $height) {
            $seen{"$row $col"}++;
            $height = $treescape[$row][$col];
        }
    }
}

for my $col (0..$colEnd) {
    # scan downward
    my $height = -1;
    for my $row (0..$rowEnd) {
        if ($treescape[$row][$col] > $height) {
            $seen{"$row $col"}++;
            $height = $treescape[$row][$col];
        }
    }

    # scan up
    $height = -1;
    for my $row (reverse 0..$rowEnd) {
        if ($treescape[$row][$col] > $height) {
            $seen{"$row $col"}++;
            $height = $treescape[$row][$col];
        }
    }
}

say scalar keys %seen;
