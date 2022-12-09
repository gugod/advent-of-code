my %V := {
    "U" => [-1,  0],
    "D" => [ 1,  0],
    "L" => [ 0, -1],
    "R" => [ 0,  1],
};

sub move-knot (@rope, Int $i, $dir) {
    @rope[$i] <<+=>> %V{$dir}
}

sub move-head (@rope, $dir) {
    move-knot(@rope, 0, $dir);
}

sub move-body-and-tail (@rope) {
    for 1..@rope.end() -> $i {
        my ($delta-rows, $delta-cols) = @rope[$i-1] <<->> @rope[$i];

        return if (abs($delta-cols), abs($delta-rows)).all() < 2;

        my @moves;
        if $delta-cols == 0 || $delta-rows != 0  {
            @moves.push: $delta-rows < 0 ?? "U" !! "D";
        }
        if $delta-rows == 0 || $delta-cols != 0 {
            @moves.push: $delta-cols < 0 ?? "L" !! "R";
        }

        last if @moves == 0;

        for @moves -> $dir {
            move-knot(@rope, $i, $dir);
        }
    }
}

sub MAIN ( $in = "input" ) {
    my %seen;
    my @rope = ([0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]);

    %seen{@rope.tail()} = True;
    $in.IO.lines.map({ .split(" ") }).map: -> [$dir, $steps] {
        for ^$steps {
            move-head(@rope, $dir);
            move-body-and-tail(@rope);
            %seen{@rope.tail()} = True;
        }
    }

    say %seen.keys.elems;
}
