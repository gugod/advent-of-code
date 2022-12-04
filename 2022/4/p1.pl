use v5.36;
open my $fh, "<", "input.txt";

say 0+ grep {
    my @bounds = $_ =~ m/([0-9]+)/g;

    ($bounds[0] <= $bounds[2] <= $bounds[3] <= $bounds[1])
        || ($bounds[2] <= $bounds[0] <= $bounds[1] <= $bounds[3])
}
<$fh>;
