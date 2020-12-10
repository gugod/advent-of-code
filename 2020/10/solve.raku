my @adapters = "input".IO.lines.map: *.Int;

my @joltages = (0, @adapters.max + 3, |@adapters).sort;
my @deltas = @joltages.rotor(2 => -1).map({ .[1] - .[0] });
my %delta-histogram = ({}, |@deltas).reduce({ $^a{$^b}++; $^a });

say "Part 1: " ~ ([*] %delta-histogram<1 3>);
