
my @stacks;

my ($part1, $part2) = "input".IO.slurp.split("\n\n");
for $part1.split("\n") -> $line {
    my @plates = $line.comb.pairs.grep({ .key % 4 == 1 }).map({ .value });
    for @plates.kv -> $i, $v {
        next if $v eq ' ';
        @stacks[$i].push: $v;
    }
};
@stacks = @stacks.map({ $_.reverse.Array });

my @instructions = $part2.split("\n").grep({ /^move/ }).map({ .comb(/\d+/).Array });

for @instructions -> ($plates, $from, $to) {
    @stacks[$to - 1].append: @stacks[$from - 1].splice(* - $plates);
}

@stacks.map({ .[*-1] }).join("").say;
