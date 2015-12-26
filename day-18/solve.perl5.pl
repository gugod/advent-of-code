use v5.20;

sub load_input {
    my @state;
    open my $fh, "<", "input";
    my %s = ( '.' => 0, '#' => 1 );
    while (<$fh>) {
        chomp;
        my @s = map { $s{$_} } split "", $_;
        push @state, \@s;
    }
    close($fh);
    return \@state;
}

sub mutate {
    my ($current_state) = @_;
    my $new_state = [];
    my $w = 0 + @$current_state;
    my $h = 0 + @{$current_state->[0]};
    for my $i (0..$w-1) {
        for my $j (0..$h-1) {
            my $neighbors_on = 0;
            my @n;
            for my $i2 (grep { 0 <= $_ && $_ < $w } ($i-1, $i, $i+1)) {
                for my $j2 (grep { 0 <= $_ && $_ < $h } ($j-1, $j, $j+1)) {
                    next if $i2 == $i && $j2 == $j;
                    $neighbors_on++ if $current_state->[$i2][$j2];
                }
            }
            if ($current_state->[$i][$j]) {
                $new_state->[$i][$j] = ($neighbors_on == 2 || $neighbors_on == 3) ? 1 : 0;
            } else {
                $new_state->[$i][$j] = ($neighbors_on == 3) ? 1 : 0;
            }
        }        
    }
    return $new_state;
}

sub count_lights_on {
    my ($current_state) = @_;
    my $total = 0;
    my $w = 0 + @$current_state;
    my $h = 0 + @{$current_state->[0]};
    for my $i (0..$w-1) {
        for my $j (0..$h-1) {
            if ($current_state->[$i][$j] == 1) {
                $total++;
            }
        }        
    }
    return $total;
}

my $light_state = load_input();

for (0..99) {
    $light_state = mutate($light_state);
}

say "Part 1: " . count_lights_on($light_state);
