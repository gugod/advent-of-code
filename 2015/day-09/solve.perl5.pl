use v5.20;
sub compute_path_length {
    my ($distance, $path) = @_;
    my $total = 0;
    for my $i (1..$#$path) {
        $total += $distance->{$path->[$i-1]}{$path->[$i]};
    }
    return $total;
}

sub uniq {
    my %seen = map { $_ => 1 } @_;
    return keys %seen;
}

my $state = 0;
sub next_gen {
    return (7,6,4,5,3,1,2,0) if $state++ == 0;
    return ();
}

my %distance;
open my $fh, "<", "input";
while (<$fh>) {
    chomp($_);
    my ($f,$t,$d) = split /\s*(?:to|=)\s*/;
    $distance{$f}{$t} = $d;
    $distance{$t}{$f} = $d;
}
close($fh);

my @destinations = keys %distance;
die "Cannot do it" if @destinations > 10;

my $first_permutation = join("", "0" .. @destinations-1);
my $last_permutation = reverse($first_permutation);

my %path_length;
for my $p ($first_permutation .. $last_permutation) {
    my @p = split "", $p;
    next unless uniq(grep { $_ < @destinations } @p) == @destinations;
    $path_length{$p} = compute_path_length(\%distance, [map { $destinations[$_] } @p]);
}

my ($min_distance, $min_path, $max_distance, $max_path);
my @paths = keys %path_length;
$max_path = $min_path = pop(@paths);
$max_distance = $min_distance = $path_length{$min_path};

while(@paths) {
    my $p = pop(@paths);
    my $d = $path_length{$p};
    if ($d < $min_distance) {
        $min_distance = $d;
        $min_path = $p;
    }
    if ($d > $max_distance) {
        $max_distance = $d;
        $max_path = $p;
    }
}

say "Min Dinstance: $min_distance : $min_path";
say "Max Dinstance: $max_distance : $max_path";
