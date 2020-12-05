
my @nums = "input".IO.lines.map: *.Int;
for 2, 3 -> $c {
    @nums.combinations($c).first(-> @n { @n.sum == 2020 }).reduce(&infix:<*>).say;
}
