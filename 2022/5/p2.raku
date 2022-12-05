
my @stacks;

my ($part1, $part2) = "input".IO.slurp.split("\n\n");
for $part1.split("\n") -> $line {
    for (1, 5, 9 ... $line.chars).map({ $line.substr($_, 1) }).kv -> $i, $letter {
        next if $letter eq ' ';
        @stacks[$i].push: $letter;
    }
}
@stacks = @stacks.map({ $_.reverse.Array });

my @instructions = $part2.split("\n").grep({ /^move/ }).map({ .comb(/\d+/).Array });

for @instructions -> ($plates, $from, $to) {
    @stacks[$to - 1].append: @stacks[$from - 1].splice(* - $plates);
}

@stacks.map({ .[*-1] }).join("").say;
