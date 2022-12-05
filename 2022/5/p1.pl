use v5.36;

open my $fh, "input";
my ($part1, $part2) = split "\n\n", do { local $/; <$fh> };
close($fh);

my @stacks;

for my $line ( split("\n", $part1) ) {
    last if $line eq "\n";
    chomp($line);

    my @letters = map { substr($line, $_, 1) }grep { $_ % 4 == 1 } (1...length($line));
    for my $i (0..$#letters) {
        next if $letters[$i] eq ' ';
        push @{$stacks[$i] //=[]}, $letters[$i];
    }
}
@stacks = map { [reverse(@$_)] } @stacks;

my @instructions = map { [ /(\d+)/g ] } split("\n", $part2);

for (@instructions) {
    my ($plates, $from, $to) = @$_;
    $from -= 1;
    $to -= 1;

    for (1..$plates) {
        my $p = pop(@{$stacks[$from]});
        last unless defined($p);
        push @{$stacks[$to]}, $p;
    }
}

say join "", map { $_->[-1] } @stacks;
