use v5.36;

open my $fh, "input";

my @stacks;
my @instructions;

while (<$fh>) {
    last if $_ eq "\n";
    chomp;

    my @plates = $_ =~ m/(...) ?/g;

    for my $i (0..$#plates) {
        my ($letter) = $plates[$i] =~ /([A-Z])/g;
        next unless defined $letter;
        push @{$stacks[$i] //=[]}, $letter;
    }
}
@stacks = map { [reverse(@$_)] } @stacks;

while (<$fh>) {
    my ($a,$b,$c) = $_ =~ /(\d+)/g;
    push @instructions, [$a,$b,$c];
}
close($fh);

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
