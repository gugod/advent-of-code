sub MAIN(IO::Path() $input) {
    my @lines = $input.lines.Array;

    say "Part 2: ";
    part2(@lines);
    say "Part 1: ";
    part1(@lines);
}

sub part2 (@input-lines) {
    my %pad = (
        1 => [1,1,3,1],
        2 => [2,3,6,2],
        3 => [1,4,7,2],
        4 => [4,4,8,3],
        5 => [5,6,5,5],
        6 => [2,7,'A',5],
        7 => [3,8,'B',6],
        8 => [4,9,'8',7],
        9 => [9,9,9,8],
        A => [6,'B','A','A'],
        B => [7,'C','D','A'],
        C => ['C','C','C','B'],
        D => ['B','D','D','D'],
    );
    say play-pad(%pad, @input-lines);
}

sub part1 (@input-lines) {
    my %pad = (
        1 => [1, 2, 4, 1],
        2 => [2, 3, 5, 1],
        3 => [3, 3, 6, 2],
        4 => [1, 5, 7, 4],
        5 => [2, 6, 8, 4],
        6 => [3, 6, 9, 5],
        7 => [4, 8, 7, 7],
        8 => [5, 9, 8, 7],
        9 => [6, 9, 9, 8],
    );
    say play-pad(%pad, @input-lines);
}

sub play-pad (%pad, @input-lines) {
    my $cur = 5;
    my %dir = ( :U(0), :R(1), :D(2), :L(3) );
    my @code = @input-lines.map: -> $code {
        $code.comb.map({ $cur = %pad{$cur}[ %dir{$^c} ] });
        $cur;
    };
    return @code.join;
}
