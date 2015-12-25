use v5.20;

sub uniq { my %a = map {($_=>1)} @_; keys %a };

sub compute {
    my ($cost, $lookup, $p) = @_;

    my $total_cost = 0;
    for my $j (0..$#$p) {
        my $i = ($j == 0) ? $#$p : $j-1;
        my $k = ($j == $#$p) ? 0 : $j+1;
        $total_cost += $cost->{$lookup->[$p->[$j]]}{$lookup->[$p->[$k]]} // die "Unknown cost: $lookup->[$j] => $lookup->[$k]";
        $total_cost += $cost->{$lookup->[$p->[$j]]}{$lookup->[$p->[$i]]} // die "Unknown cost: $lookup->[$j] => $lookup->[$i]";
    }
    return $total_cost;
}

open my $fh, "<", "input";
my @input = <$fh>;
close($fh);

my %happiness;
for (@input) {
    if (m/\A(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+).\n\z/) {
        $happiness{$1}{$4}=($2 eq "gain" ? 1 : -1) * $3;
    } else {
        die "wtf: $_";
    }
}

my %total_happiness;
my @guests = sort keys %happiness;

my $first_permutation = "0" . join("", 1 .. @guests-1);
my $last_permutation = "0" . join("", reverse(1 .. @guests-1));
my %path_length;
my ($min,$max) = (999999999,-1);
for my $p ($first_permutation .. $last_permutation) {
    my @p = split "", $p;
    next unless uniq(grep { $_ < @guests } @p) == @guests;
    
    my $cost = $total_happiness{$p} = compute(\%happiness, \@guests, \@p);
    # say $total_happiness{$p} . "\t" . join(",", map { $guests[$_] } @p);
    $max = $cost if $max < $cost;
    $min = $cost if $min > $cost;
}
say "Min:$min Max:$max";
