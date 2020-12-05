use v5.20;

sub uniq { my %a = map {($_=>1)} @_; keys %a };

sub compute {
    my ($cost, $lookup, $p) = @_;

    my $total_cost = 0;
    my $total_cost2 = 0;

    for my $j (0..$#$p) {
        my $i = ($j == 0) ? $#$p : $j-1;
        my $k = ($j == $#$p) ? 0 : $j+1;
        $total_cost += $cost->{$lookup->[$p->[$j]]}{$lookup->[$p->[$k]]} // 0;
        $total_cost += $cost->{$lookup->[$p->[$j]]}{$lookup->[$p->[$i]]} // 0;
    }
    return $total_cost;
}

sub compute_maximum {
    my ($happiness, $guests) = @_;
    my @guests = @$guests;
    my $first_permutation = "0" . join("", 1 .. @guests-1);
    my $last_permutation  = "0" . join("", reverse(1 .. @guests-1));
    my %path_length;
    my $max = -1;
    for my $p ($first_permutation .. $last_permutation) {
        my @p = split "", $p;
        next unless uniq(grep { $_ < @guests } @p) == @guests;
        my ($cost, $cost2) = compute($happiness, \@guests, \@p);
        if ($max < $cost) {
            $max = $cost;
        }
    }
    return $max;
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

my (@guests, $max);

@guests = keys %happiness;
$max = compute_maximum(\%happiness, \@guests);
say "Part 1: $max"; 

@guests = ("Me", keys %happiness);
$max = compute_maximum(\%happiness, \@guests);
say "Part 2: $max";
