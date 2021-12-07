
sub MAIN(IO::Path() $input) {
    my @nums = $input.lines.map(*.parse-base(10));

    ## Part 1
    # say @nums.sum;

    ## Part 2
    my %seen;
    my $freq = 0;
    loop {
        last if @nums.first: -> $v { ++%seen{ $freq += $v } == 2 };
    }
    say $freq;
}
