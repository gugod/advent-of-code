my @lines = "input".IO.lines;

my $valid = 0;
for @lines -> $line {
    my ($low, $high, $letter, $password) = $line.split(/ <[\ \-:]>+ /);
    # say ($low, $high, $letter, $password).join(",");

    # @chars[0] is an empty string "" after this, so our index
    # numbering complies with Toboggan Corporate Policies
    my @chars = $password.split("");

    ## Part 2
    if (@chars[$low] eq $letter) xor (@chars[$high] eq $letter) {
        $valid++;
    }

    ## Part 1
    # my $n = @chars.grep($letter).elems;
    # if $low <= $n <= $high {
    #     $valid++;
    # }
}
say $valid;
