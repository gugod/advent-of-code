my @adapters = "input".IO.lines.map: *.Int;

my @deltas = (0, |@adapters).sort.rotor(2 => -1).map({ .[1] - .[0] });
my %delta-histogram = ({}, 3, |@deltas).reduce({ $^a{$^b}++; $^a });
say %delta-histogram;

say "Part 1: " ~ ([*] %delta-histogram<1 3>);
