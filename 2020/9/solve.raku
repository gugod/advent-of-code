
my @xmasnums = "input".IO.lines.map({ .Int }).Array;

# Part 1
my $badnum = @xmasnums.rotor( 26 => -25 ).first(
    -> @nums {
        @nums.tail == none(  @nums.head( @nums-1 ).combinations(2).map({ .sum }) )
    }).tail;

say "Part 1: " ~ $badnum;

my @xmasleftsums = [ @xmasnums[0] ];
for 1..@xmasnums.end -> $i {
    @xmasleftsums[$i] = @xmasleftsums[$i-1] + @xmasnums[$i];
}

my $weakness;
for 0..@xmasnums.end -> $i {
    my $j = ($i+1 ... @xmasnums.end).first(
        -> $j {
            $badnum == @xmasleftsums[$j] - @xmasleftsums[$i] + @xmasnums[$i];
        });

    if $j.defined {
        my @range = @xmasnums[ $i .. $j ];
        $weakness = @range.min + @range.max;
        last;
    }
}
say "Part 2: " ~ $weakness;
