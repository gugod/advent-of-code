use v5.36;
open my $fh, "<", "input.txt";

my $count = 0;
while (<$fh>) {
    my @bounds = $_ =~ m/([0-9]+)/g;
    $count++ if (
        ($bounds[0] <= $bounds[2] <= $bounds[3] <= $bounds[1])
        || ($bounds[2] <= $bounds[0] <= $bounds[1] <= $bounds[3])
    );
}
say $count;
