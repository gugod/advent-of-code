my @seats = "input".IO.lines.map(
    -> $line is copy {
        $line ~~ tr/FBLR/0101/;
        $line.parse-base(2);
    }
);

# Part 1
say @seats.max;

# Part 2
my $seats = @seats.Set;
say (@seats.min..@seats.max).first(-> $id { $id ∉ $seats });
