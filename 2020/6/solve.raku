my @groups = "input".IO.slurp.split("\n\n").map({ .split("\n").map: *.comb });

## Part 1
# @groups.map({ .reduce({ $^a ∪ $^b }).elems }).sum.say;

# Part 2
@groups.map({ .reduce({ $^a ∩ $^b }).elems }).sum.say;
