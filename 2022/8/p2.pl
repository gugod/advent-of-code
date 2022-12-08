use v5.36;
use File::Slurp qw(slurp);
use List::Util qw(max);

my $in = slurp("input");

my @treescape = map { [ split "",  $_ ] } split "\n", $in;
my %score;
my $rowEnd = $#treescape;
my $colEnd = $#{$treescape[0]};

sub climbAndEvaluate ($row, $col) {
    if ($row == 0 || $col == 0 || $row == $rowEnd || $col == $colEnd) {
        return 0;
    }
    my $height = $treescape[$row][$col];

    my $u = 0;
    for my $r (reverse 0..($row-1)) {
        $u++;
        last if $height <= $treescape[$r][$col];
    }

    my $d = 0;
    for my $r (($row+1)..$rowEnd) {
        $d++;
        last if $height <= $treescape[$r][$col];
    }

    my $l = 0;
    for my $c (reverse 0..($col-1)) {
        $l++;
        last if $height <= $treescape[$row][$c];
    }

    my $r = 0;
    for my $c (($col+1)..$colEnd) {
        $r++;
        last if $height <= $treescape[$row][$c];
    }

    return $u * $d * $l * $r;
}

for my $row (0..$rowEnd) {
    for my $col (0..$rowEnd) {
        $score{"$row $col"} = climbAndEvaluate($row, $col);
    }
}

say max(values %score);
