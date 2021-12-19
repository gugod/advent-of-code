
sub MAIN(IO::Path() $input) {
    my @readings;
    my $scanner;
    for $input.lines -> $line {
        if $line ~~ /scanner\s+(\d+)/ {
            $scanner = $0.Int;
            @readings[$scanner] = [];
        } else {
            @readings[$scanner].push($line.split(/\,/).Array);
        }
    }

}
