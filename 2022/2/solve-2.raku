
my %score = ('A','B','C','X','Y','Z') Z=> (1,2,3,0,3,6);

sub MAIN() {
    say sum "input.txt".IO.lines.map: -> $line {
        my ($them, $win) = $line.split(" ").map({ %score{$_} });

        $win + ((do {
            given $win {
                when 0 { $them - 1 }
                when 3 { $them }
                when 6 { $them + 1 }
            }
        } -1) % 3 + 1);
    };
}
