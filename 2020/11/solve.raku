
my @seatmap = "input".IO.lines.map({ .chomp.comb.Array }).Array;
# print-seatmap(@seatmap);

my $rows = @seatmap.elems;
my $cols = @seatmap[0].elems;

my @seats := ([^$rows] X [^$cols]).grep(-> ($j,$i) { @seatmap[$j][$i] ne '.' }).Array;
my @dirs := ((-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)).Array;

say "... Start the construction of a 4D pocket";
my $progress = 0;
my @seats-at-dir;
for @seats -> ($j, $i) {
    for @dirs -> $dir {
        # Since I was a kid, I've always been wondering what creatures lives in the 4th dimension.
        # It looks like that is a seat.
        @seats-at-dir[$j][$i]{$dir[0]}{$dir[1]} = (1..max($rows,$cols)).map(
            -> $radius { $dir >>*>> $radius <<+>> ($j,$i)  }
        ).grep(
            { 0 <= .[0] < $rows && 0 <= .[1] < $cols }
        ).first(
            { @seatmap[ .[0] ][ .[1] ] ne "." }
        );
    }
    # say "...... { ($progress++ / @seats * 10000).Int / 100 } percent done";
}

say "... Finished the construction of a 4D pocket. That took no time.";

my $rounds = 0;

say "... Round $rounds, occupied seats: " ~ occupied-seats(@seats, @seatmap);

my @changing-seats = ((0,0,'#'));
while @changing-seats.elems > 0 {
    $rounds++;
    @changing-seats = ();

    for @seats -> ($j, $i) {
        my $occupied-seats = @dirs.grep(
            -> $dir {
                # Time to summon the beast^Wseat from the 4th dimention
                my $seat = @seats-at-dir[$j][$i]{$dir[0]}{$dir[1]};
                $seat && @seatmap[ $seat[0] ][ $seat[1] ] eq '#';
            }).elems;

        if $occupied-seats == 0 && @seatmap[$j][$i] eq "L" {
            push @changing-seats, ($j, $i, "#");

        } elsif $occupied-seats >= 5 && @seatmap[$j][$i] eq "#" {
            push @changing-seats, ($j, $i, "L");
        }
    }
    for @changing-seats -> ($j, $i, $sym) {
        @seatmap[$j][$i] = $sym;
    }
    # say "... Round $rounds";
    say "... Round $rounds, occupied seats: " ~ occupied-seats(@seats, @seatmap);
}

say "The end, occupied seats: " ~ occupied-seats(@seats, @seatmap);

exit;

sub occupied-seats(@seats, @seatmap) {
    @seats.grep({ @seatmap[ .[0] ][ .[1] ] eq '#' }).elems;
}

sub print-seatmap(@seatmap) {
    for @seatmap -> @row {
        say @row.join;
    }
    say " ";
}
