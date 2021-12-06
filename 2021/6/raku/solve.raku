
sub MAIN(IO::Path() $input) {
    # .Array is not needed, if you assign to an array variable a list will
    # become an array automatically.
    my @nums = $input.lines.comb(/\d+/);

    play-latternfish(@nums, 256);
}

sub play-latternfish (@nums, $days) {
    my @gen = 0 xx 9;
    
    # Personally, I don't like map in void context
    @nums.map({ @gen[$_]++ });

    # You hardly ever need explicit loop counters
    # and if you do, you won't have to increase them
    # manually like an animal
    for ^$days {
        @gen = (@gen[1..6], @gen[0,7].sum, @gen[8,0]).flat;
    }
    
    # since we allready have an array, there is no need to call .values on it
    # that's a no-op
    say @gen.sum;
}
