use v5.30;

my @seats = map {
    tr/FBLR/0101/;

    # Not the best way to do parse-int(2), but works for the input of this puzzle.
    eval "0b$_";
} @{ lines("input") };

# Part 1
my ($min, $max) = minmax(@seats);
say $max;

# Part 2
my %seats = map { $_ => 1 } @seats;
for my $id ($min ... $max) {
    if (not exists $seats{$id}) {
        say $id;
        last;
    }
}

# Utility functions
sub minmax {
    my @nums = @_;
    my $min = $nums[0];
    my $max = $nums[0];
    for (@nums) {
        $min = $_ if $_ < $min;
        $max = $_ if $_ > $max;
    }
    return ($min, $max);
}

sub lines {
    my ($file) = @_;
    my @lines;

    open my $fh, '<', $file;
    while (<$fh>) {
        push @lines, $_;
    }
    close($fh);

    return \@lines;
}
