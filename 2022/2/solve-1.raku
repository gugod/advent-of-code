
my %score = ('A','B','C','X','Y','Z') Z=> (1,2,3,1,2,3);

sub MAIN() {
    say sum "input.txt".IO.lines.map: -> $line {
        my ($them, $me) = $line.split(" ").map({ %score{$_} });

        $me + do {
            given ($them - $me) {
                when 1|-2 { 0 }
                when 0    { 3 }
                default   { 6 }
            }
        };
    };
}
