use v5.36;
use Data::Dumper qw(Dumper);

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

# vis(\@stacks);

for (@instructions) {
    my ($plates, $from, $to) = @$_;
    $from -= 1;
    $to -= 1;
    # say "move: $plates $from $to";

    my @p;
    for (1..$plates) {
        unshift @p, pop(@{$stacks[$from]});
    }

    push @{$stacks[$to]}, @p;

    # vis(\@stacks);
    # say "----";
}

say join "", map { $_->[-1] // "[]" } @stacks;

use JSON::PP qw(encode_json);
sub vis ($stacks) {
    for my $s (@$stacks) {
        say "+ " . encode_json($s);
    }
}
