my @adapters = "input".IO.lines.map: *.Int;

my @joltages = (0, @adapters.max + 3, |@adapters).sort;
my @deltas = @joltages.rotor(2 => -1).map({ .[1] - .[0] });
my %delta-histogram = ({}, |@deltas).reduce({ $^a{$^b}++; $^a });

say "Part 1: " ~ ([*] %delta-histogram<1 3>);

my @ways = (1);

for 1..@joltages.end -> $i {
    @ways[$i] = [$i-3, $i-2, $i-1].grep({ $^j >= 0 }).grep({ 1 <= @joltages[$i] - @joltages[$^j] <= 3 }).map({ @ways[$^j] }).sum;
}

say "Part 2: " ~ @ways.tail;
