
sub MAIN(IO::Path() $input) {
    my @nums = $input.lines.comb(/\d+/).Array;
    # my @nums = (3,4,3,1,2);
    # play-latternfish(@nums, 80);
    play-latternfish(@nums, 256);
}

sub play-latternfish (@nums, $days) {
    my @gen = 0 xx 9;
    @nums.map({ @gen[$_]++ });
    my $days_passed = 0;
    while $days_passed++ < $days {
        @gen = (@gen[1..6], @gen[0,7].sum, @gen[8,0]).flat;
    }
    say @gen.values.sum;
}
