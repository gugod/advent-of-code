
sub MAIN(IO::Path() $input) {
    # Part 2: mediocre completion.
    my @scores;
    for $input.lines -> $line {
        my ($score, $completer) = corruption($line);
        next if $score > 0;
        @scores.push: completion-score($completer);
    }
    say @scores.sort.[ @scores.elems / 2 ];
}

sub completion-score($s) {
    constant %score = ( ')' => 1, ']' => 2, '}' => 3, '>' => 4 );
    my $score = 0;
    for $s.comb -> $c {
        $score = ($score * 5) + %score{$c};
    }
    return $score;
}

sub corruption (Str $noise) {
    constant %score = ( ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 );
    constant %closer-of = '()[]{}<>'.comb.pairup;

    my @stack;
    my $score = 0;

    $noise.comb.first: -> $c {
        if %closer-of{$c}:exists {
            @stack.push($c);
        } else {
            if $c ne %closer-of{ @stack.pop } {
                $score += %score{$c};
            }
        }
        $score != 0;
    }

    return ($score, @stack.map({ %closer-of{$_} }).reverse.join);
}
