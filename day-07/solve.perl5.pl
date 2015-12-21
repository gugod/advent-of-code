use v5.20;

sub looks_like_a_number { $_[0] =~ /\A [0-9]+ \z/x }
my %val; # Hash[ undef | Number ]
my %rule;
open my $fh, "<", "input";
while (<$fh>) {
    chomp;
    my $line = $_;
    next unless $line =~ /^(.+)\s->\s([a-z]+)/;
    my ($lhs, $rhs) = ($1, $2);
    $rule{$rhs} = $lhs;
    my @o = split / /, $lhs;
    if (@o == 3) {
        $rule{$rhs} = [$o[0], $o[2], $o[1]]
    } else {
        $rule{$rhs} = [reverse @o];
    }
}
close($fh);

sub eval_one_round {
    for my $k (grep { !defined($val{$_}) } keys %rule) {
        my @o = @{$rule{$k}};
        if (@o == 3) {
            my ($va, $vb) = map { looks_like_a_number($_) ? $_ : $val{$_} } ($o[0], $o[1]);
            next unless defined($va) && defined($vb);
            my $op = $o[2];
            if ($op eq "AND") {
                $val{$k} = $va & $vb;
            } elsif ($op eq 'OR') {
                $val{$k} = $va | $vb;
            } elsif ($op eq 'LSHIFT') {
                $val{$k} = $va << $vb;
            } elsif ($op eq 'RSHIFT') {
                $val{$k} = $va >> $vb;
            } else {
                die "WTF RULE: $k " . join(" ", @o);
            }
        } elsif (@o == 2) {
            if ($o[1] eq 'NOT') {
                if (looks_like_a_number($o[0])) {
                    $val{$k} = ~ $o[0];
                } else {
                    $val{$k} = ~$val{$o[0]} if defined($val{$o[0]});
                }
            } else {
                die "WTF RULE: $k " . join(" ", @o);
            }
        } elsif (@o == 1) {
            if (looks_like_a_number($o[0])) {
                $val{$k} = $o[0];
            } else {
                $val{$k} = $val{$o[0]} if $val{$o[0]};
            }
        } else {
            die "WTF RULE: $k " . join(" ", @o);
        }
    }
}

my $rounds = 0;
while (!defined($val{a}) && $rounds <= (keys %rule)) {
    eval_one_round();
    $rounds++;
}

say "Part 1: $val{a}";
